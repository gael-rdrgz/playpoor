import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:playerbloc/blocs/player_bloc.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/blocs/player_load_states.dart';
import 'package:playerbloc/blocs/player_state.dart';

class Botonera extends StatelessWidget {

  final Color color;

  const Botonera({
    required this.color,
    super.key
  });

  String timeFormat(int seconds) {
    final int min = (seconds / 60).floor();
    final int res = seconds % 60;
    return "${min.toString().padLeft(2, '0')}:${res.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final double porcentaje = .08;

    return BlocBuilder<PlayerBloc, PlayState>(
      builder: (context, state) {
        final Duration position = state is PlayingState ? state.position : Duration.zero;
        final Duration duration = state is PlayingState ? state.duration : Duration.zero;
        final bool isPlaying = state is PlayingState && state.isPlaying;
        double progress = duration.inSeconds > 0 ? position.inSeconds / duration.inSeconds : 0.0;

        return SizedBox(
          width: screenW * .75,
          height: screenH * .3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(timeFormat(position.inSeconds)),
              CircularPercentIndicator(
                progressColor: color,
                backgroundColor: Colors.blueGrey,
                circularStrokeCap: CircularStrokeCap.round,
                arcType: ArcType.HALF,
                radius: screenW * .25,
                lineWidth: 3,
                percent: progress.clamp(0.0, 1.0),
                center: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        iconSize: screenW * porcentaje,
                        onPressed: (){

                        },
                        icon: Icon(Icons.skip_previous_rounded)
                      ),
                      IconButton(
                        iconSize: screenW * porcentaje,
                        onPressed: () {
                          context.read<PlayerBloc>().add(PlayPauseEvent());
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                        ),

                      ),
                      IconButton(
                          iconSize: screenW * porcentaje,
                          onPressed: (){

                          },
                          icon: Icon(Icons.skip_next_rounded)
                      )
                    ],
                  ),
                ),
              ),
              Text(timeFormat(duration.inSeconds)),
            ],
          ),
        );
      },
    );
  }
}
