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
    setup();
  }

  FutureOr<void> cargando(
    PlayerLoadEvent event,
    Emitter<PlayState> emit,
  ) async {
    try {
      emit(LoadingState()); //mandar estado a la ui
      await audioPlayer?.stop();
      await audioPlayer?.setSourceAsset(canciones[event.index].assetPath);
      emit(
        PlayingState(
          currentIndex: event.index,
          duration: Duration.zero,
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

  void setup() {
    posicion = audioPlayer.onPositionChanged.listen((event) {
      if (state is PlayingState) {
        final PlayingState estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(position: estadoActual.position));
      }
    });

    duracion = audioPlayer.onDurationChanged.listen((event) {
      if (state is PlayingState) {
        final PlayingState estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(duration: estadoActual.duration));
      }
    });

    estado = audioPlayer.onPlayerStateChanged.listen((event) {
      //si la cancion se esta reproduciendo
      if (state == PlayerState.playing){ //player state de dart
        if (event is PlayingState){
          final PlayingState estadoActual = event as PlayingState;
          if (!estadoActual.isPlaying){
            add (PlayEvent());
          }
        }
      }
      if (state == PlayerState.paused){
        if (event is PlayingState){
          final PlayingState estadoActual = event as PlayingState;
          if (estadoActual.isPlaying){
            add (PlayPauseEvent());
          }
        }
      }
    },);
  }
  @override
  Future<void> close() {
    estado?.cancel();
    posicion?.cancel();
    duracion?.cancel();
    audioPlayer.dispose();

    return super.close();
  }
}
