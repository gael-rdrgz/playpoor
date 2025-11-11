import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerbloc/blocs/player_bloc.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/blocs/player_load_states.dart';
import 'package:playerbloc/blocs/player_state.dart';

class ProgressSlider extends StatelessWidget {
  final Color color;

  const ProgressSlider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayState>(
      builder: (context, state) {
        final Duration position = state is PlayingState
            ? state.position
            : Duration.zero;
        final Duration duration = state is PlayingState
            ? state.duration
            : Duration.zero;
        return SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          // height: MediaQuery.of(context).size.height * .3,
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: color,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
              activeTrackColor: color,
              inactiveTrackColor: Colors.grey[200],
              overlayColor: Colors.transparent,
            ),
            child: Slider(
              value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
              max: duration.inSeconds.toDouble(),
              min: 0,
              onChanged: (value) {
                context.read<PlayerBloc>().add(SeekEvent(Duration(seconds: value.toInt())));
              },
            ),
          ),
        );
      },
    );
  }
}
