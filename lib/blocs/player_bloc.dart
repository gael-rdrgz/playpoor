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
  StreamSubscription? posicion, duracion, estado;

  PlayerBloc({required this.audioPlayer, required this.canciones})
    : super(InitialState()) {
    on<PlayerLoadEvent>(cargando);
    on<PlayEvent>(reproduciendo);
    on<PauseEvent>(pausando);
    on<PlayPauseEvent>(alternando);
    on<PrevEvent>(cambiandoAnterior);
    on<NextEvent>(cambiandoSiguiente);
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

    estado = audioPlayer.onPlayerStateChanged.listen((event) {
      if (state is! PlayingState) return;
      final PlayingState estadoActual = state as PlayingState;

      if (event == PlayerState.playing) {
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
    });
  }

  FutureOr<void> cargando(
    PlayerLoadEvent event,
    Emitter<PlayState> emit,
  ) async {
    try {
      emit(LoadingState()); //mandar estado a la ui
      await audioPlayer?.stop();
      await audioPlayer?.setSourceAsset(canciones[event.index].assetPath);

      final duration = await audioPlayer.getDuration();

      emit(
        PlayingState(
          currentIndex: event.index,
          duration: duration ?? Duration.zero,
          position: Duration.zero,
          isPlaying: true,
        ),
      );
      add(PlayEvent());
    } catch (e) {
      emit(
        ErrorState("Error: De alguna manera, en algún lugar, algo salió mal."),
      ); //emit para estados, add para eventos
      debugPrint(e.toString());
    }
  }

  FutureOr<void> reproduciendo(PlayEvent event, Emitter<PlayState> emit) async {
    //si está en estado de reproduccion
    if (state is PlayingState) {
      try {
        await audioPlayer?.resume();
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
    audioPlayer.dispose();

    return super.close();
  }

  FutureOr<void> cambiandoAnterior(
    PrevEvent event,
    Emitter<PlayState> emit,
  ) async {
    final estadoActual = state as PlayingState;
    int index = estadoActual.currentIndex;

    if (index > 0) {
      index = index - 1;
    } else {
      index = canciones.length - 1;
    }

    add(PlayerLoadEvent(index));
  }

  FutureOr<void> cambiandoSiguiente(
    NextEvent event,
    Emitter<PlayState> emit,
  ) async {
    final estadoActual = state as PlayingState;
    int index = estadoActual.currentIndex;

    if (index < canciones.length) {
      index = index + 1;
    }
    if (index == canciones.length) {
      index = 0;
    }

    add(PlayerLoadEvent(index));
  }
}
