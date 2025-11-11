import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:playerbloc/blocs/player_event.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/blocs/player_load_states.dart';
import 'package:playerbloc/blocs/player_state.dart';
import 'package:playerbloc/models/audio_item.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayState> {
  final AudioPlayer audioPlayer;
  final List<AudioItem> canciones;
  StreamSubscription? posicion, duracion, estado, completo;
  bool _canAutoAdvance = true;

  PlayerBloc({required this.audioPlayer, required this.canciones})
    : super(InitialState()) {
    on<PlayerLoadEvent>(cargando);
    on<PlayEvent>(reproduciendo);
    on<PauseEvent>(pausando);
    on<PlayPauseEvent>(alternando);
    on<PrevEvent>(cambiandoAnterior);
    on<NextEvent>(cambiandoSiguiente);
    on<SeekEvent>(cambiandoPosicion);
    on<VolumeChangedEvent>(volumenCambiado);
    on<SpeedChangedEvent>(velocidadCambiada);
    setup();
  }

  void setup() {
    posicion = audioPlayer.onPositionChanged.listen((pos) {
      if (state is PlayingState) {
        final PlayingState estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(position: pos));
      }
    });

    duracion = audioPlayer.onDurationChanged.listen((dur) async {
      if (state is PlayingState) {
        final PlayingState estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(duration: dur));
      }
    });

    completo = audioPlayer.onPlayerComplete.listen((event) {
      if (state is PlayingState && _canAutoAdvance) {
        debugPrint("Autoavance activado");
        add(NextEvent());
      }
    });

    estado = audioPlayer.onPlayerStateChanged.listen((event) {
      if (state is! PlayingState) return;
      final PlayingState estadoActual = state as PlayingState;

      if (event == PlayerState.playing) {
        _canAutoAdvance = true;
        if (event is PlayingState) {
          if (!estadoActual.isPlaying) {
            add(PlayEvent());
          }
        }
      }
      if (event == PlayerState.paused) {
        if (event is PlayingState) {
          if (estadoActual.isPlaying) {
            add(PlayPauseEvent());
          }
        }
      }

      /*if (estadoActual.duration == estadoActual.position){
        add(NextEvent());
      }*/
    });
  }

  FutureOr<void> cargando(
    PlayerLoadEvent event,
    Emitter<PlayState> emit,
  ) async {
    try {
      debugPrint('>>> CARGANDO canción en índice: ${event.index}');
      debugPrint('>>> Archivo: ${canciones[event.index].assetPath}');
      completo?.pause();
      _canAutoAdvance = false;
      emit(LoadingState()); //mandar estado a la ui

      final currentVolume = state is PlayingState
          ? (state as PlayingState).volume
          : 1.0;

      final currentSpeed = state is PlayingState
          ? (state as PlayingState).playSpeed
          : 1.0;

      await audioPlayer.stop();
      await audioPlayer.setSourceAsset(canciones[event.index].assetPath);

      final duration = await audioPlayer.getDuration();

      emit(
        PlayingState(
          currentIndex: event.index,
          duration: duration ?? Duration.zero,
          position: Duration.zero,
          isPlaying: true,
          volume: currentVolume,
        ),
      );

      completo?.resume();
      await audioPlayer.setVolume(currentVolume);
      await audioPlayer.setPlaybackRate(currentSpeed);
      add(PlayEvent());
    } catch (e) {
      emit(
        ErrorState("Error: Todo lo que ha podido fallar lo ha hecho."),
      ); //emit para estados, add para eventos
      debugPrint(e.toString());
    }
  }

  FutureOr<void> reproduciendo(PlayEvent event, Emitter<PlayState> emit) async {
    //si está en estado de reproduccion
    if (state is PlayingState) {
      try {
        await audioPlayer.resume();
        //await audioPlayer?.pause();

        final PlayingState estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(isPlaying: true));
      } catch (e) {
        emit(
          ErrorState(
            "Error: De alguna manera, en algún lugar, algo salió mal.",
          ),
        );
        debugPrint(e.toString());
      }
    }
  }

  FutureOr<void> pausando(PauseEvent event, Emitter<PlayState> emit) async {
    if (state is PlayingState) {
      try {
        await audioPlayer.pause();
        final estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(isPlaying: false));
      } catch (e) {
        emit(ErrorState("Error: No se pudo pausar"));
        debugPrint(e.toString());
      }
    }
  }

  FutureOr<void> alternando(
    PlayPauseEvent event,
    Emitter<PlayState> emit,
  ) async {
    if (state is PlayingState) {
      final estadoActual = state as PlayingState;
      if (estadoActual.isPlaying) {
        add(PauseEvent());
      } else {
        add(PlayEvent());
      }
    }
  }

  @override
  Future<void> close() {
    estado?.cancel();
    posicion?.cancel();
    duracion?.cancel();
    completo?.cancel();
    audioPlayer.dispose();

    return super.close();
  }

  FutureOr<void> cambiandoAnterior(
    PrevEvent event,
    Emitter<PlayState> emit,
  ) async {
    final estadoActual = state as PlayingState;
    int index = estadoActual.currentIndex;
    _canAutoAdvance = false;

    if (estadoActual.position < Duration(seconds: 1)) {
      if (index > 0) {
        index = index - 1;
      } else {
        index = canciones.length - 1;
      }
    } else {
      add(
        PlayerLoadEvent(index),
      ); //regresar cancion al inicio si la posicion no es menor a 1
      return;
    }

    add(PlayerLoadEvent(index));
  }

  FutureOr<void> cambiandoSiguiente(
    NextEvent event,
    Emitter<PlayState> emit,
  ) async {
    final estadoActual = state as PlayingState;
    int index = estadoActual.currentIndex;

    debugPrint('=== NEXT EVENT ===');
    debugPrint('Índice actual: $index');
    debugPrint('Total de canciones: ${canciones.length}');

    _canAutoAdvance = false;

    index = index + 1;
    if (index >= canciones.length) {
      index = 0;
    }
    debugPrint('Nuevo índice: $index');
    debugPrint('==================');

    add(PlayerLoadEvent(index));
  }

  FutureOr<void> cambiandoPosicion(
    SeekEvent event,
    Emitter<PlayState> emit,
  ) async {
    await audioPlayer.seek(event.position);
  }

  FutureOr<void> volumenCambiado(
    VolumeChangedEvent event,
    Emitter<PlayState> emit,
  ) async {
    if (state is PlayingState) {
      final estado = state as PlayingState;
      emit(estado.copyWith(volume: event.volume));

      await audioPlayer.setVolume(event.volume);
    }
  }

  FutureOr<void> velocidadCambiada(
    SpeedChangedEvent event,
    Emitter<PlayState> emit,
  ) async {
    if (state is PlayingState) {
      final estado = state as PlayingState;
      emit(estado.copyWith(playSpeed: event.speed));

      await audioPlayer.setPlaybackRate(event.speed);
    }
  }
}
