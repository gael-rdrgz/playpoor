import 'dart:ui';

import 'package:playerbloc/blocs/player_state.dart';

class InitialState extends PlayState {}

class LoadingState extends PlayState {}

class PlayingState extends PlayState {
  final int currentIndex;
  final Duration duration;
  final Duration position;
  final bool isPlaying;

  PlayingState({
    required this.currentIndex,
    required this.duration,
    required this.position,
    required this.isPlaying,
  });

  @override
  List<Object> get props => [currentIndex, duration, position, isPlaying];

  PlayingState copyWith({
    int? currentIndex,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
  }) {
    return PlayingState(
      currentIndex: currentIndex ?? this.currentIndex,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

class ErrorState extends PlayState {
  final String msg;
  const ErrorState(this.msg);
  @override
  List<Object> get props => [msg];
}

class PlayPauseState extends PlayState {
  @override
  List<Object> get props => [];
}
