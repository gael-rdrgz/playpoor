import 'package:playerbloc/blocs/player_state.dart';

class InitialState extends PlayState {}

class LoadingState extends PlayState {}

class PlayingState extends PlayState {
  final int currentIndex;
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final double volume;
  final double playSpeed;

  const PlayingState({
    required this.currentIndex,
    required this.duration,
    required this.position,
    required this.isPlaying,
    this.volume = 1.0,
    this.playSpeed = 1.0
  });

  @override
  List<Object> get props => [currentIndex, duration, position, isPlaying, volume, playSpeed];

  PlayingState copyWith({
    int? currentIndex,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
    double? volume,
    double? playSpeed
  }) {
    return PlayingState(
      currentIndex: currentIndex ?? this.currentIndex,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
      playSpeed: playSpeed ?? this.playSpeed
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

class ConfigState extends PlayState {
  final double volume, speed;
  final Duration position, duration;
  final bool isPlaying;

  const ConfigState({
    required this.volume,
    required this.speed,
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  ConfigState copyWith(
      {double? volume, double? speed, Duration? position, Duration? duration, bool? isPlaying}) {
    return ConfigState(
        volume: volume ?? this.volume,
        speed: speed ?? this.speed,
        position: position ?? this.position,
        duration: duration ?? this.duration,
        isPlaying: isPlaying ?? this.isPlaying
    );
  }
}
