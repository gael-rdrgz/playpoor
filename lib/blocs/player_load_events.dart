import 'package:playerbloc/blocs/player_event.dart';

class PlayerLoadEvent extends PlayerEvent {
  final int index;

  const PlayerLoadEvent(this.index);

  @override
  List<Object> get props => [index];
}

class PlayEvent extends PlayerEvent {}

class PauseEvent extends PlayerEvent {}

class NextEvent extends PlayerEvent {}

class PrevEvent extends PlayerEvent {}

class PlayPauseEvent extends PlayerEvent {}

class SeekEvent extends PlayerEvent {
  final Duration position;

  const SeekEvent(this.position);

  @override
  List<Object> get props => [position];
}

class VolumeChangedEvent extends PlayerEvent {
  final double volume;

  const VolumeChangedEvent(this.volume);
}

class SpeedChangedEvent extends PlayerEvent {
  final double speed;

  const SpeedChangedEvent(this.speed);
}

class UpdateSongInfoEvent extends PlayerEvent {
  final Duration position, duration;
  final bool isPlaying;

  const UpdateSongInfoEvent({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });
}
