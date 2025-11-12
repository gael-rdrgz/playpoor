import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerbloc/blocs/player_bloc.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/blocs/player_state.dart';

import '../blocs/player_load_states.dart';

class ConfModal extends StatelessWidget {
  final PlayerBloc? bloc;

  const ConfModal({super.key, required this.bloc});

  String timeFormat(int seconds) {
    final int min = (seconds / 60).floor();
    final int res = seconds % 60;
    return "${min.toString().padLeft(2, '0')}:${res.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayState>(
      bloc: bloc,
      builder: (context, state) {
        final currentVolume = state is PlayingState ? state.volume : 1.0;
        final currentSpeed = state is PlayingState ? state.playSpeed : 1.0;
        final currentState = state is PlayingState ? state.isPlaying : false;
        final currentDuration = state is PlayingState
            ? state.duration
            : Duration.zero;
        final currentPosition = state is PlayingState
            ? state.position
            : Duration.zero;

        return Container(
          height: MediaQuery.of(context).size.height * 1 / 2,
          decoration: BoxDecoration(
            color: Color(0xfff2e4e9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            spacing: 6,
            children: [
              SizedBox(height: 16),
              Text(
                "Configuración de audio",
                style: TextStyle(
                  fontFamily: "DMSerif",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2b0d0d),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (currentVolume > 0) {
                        final volumenNuevo = (currentVolume - 0.05).clamp(
                          0.0,
                          1.0,
                        );
                        bloc?.add(VolumeChangedEvent(volumenNuevo));
                      }
                    },
                    icon: Icon(Icons.volume_down_rounded),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: Color(0xffc84b64),
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                      activeTrackColor: Color(0xffc84b64),
                      inactiveTrackColor: Colors.grey[200],
                      overlayColor: Colors.transparent,
                    ),
                    child: Slider(
                      value: currentVolume,
                      min: 0,
                      max: 1.0,
                      divisions: 100,
                      onChanged: (value) {
                        bloc?.add(VolumeChangedEvent(value));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (currentVolume < 1) {
                        final volumenNuevo = (currentVolume + 0.05).clamp(
                          0.0,
                          1.0,
                        );
                        bloc?.add(VolumeChangedEvent(volumenNuevo));
                      }
                    },
                    icon: Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
              Text(
                "Volumen: ${(currentVolume * 100).round()}%",
                style: TextStyle(color: Color(0xff6e3b3b)),
              ),
              SizedBox(height: 8),
              Text(
                "Velocidad de reproducción",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: "DMSerif",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff2b0d0d),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .85,
                child: Center(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(
                          "0.5x",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2b0d0d),
                          ),
                        ),
                        selected: currentSpeed == 0.5,
                        selectedColor: Color(0xfff2d6d6),
                        onSelected: (selected) {
                          bloc?.add(SpeedChangedEvent(0.5));
                        },
                      ),
                      ChoiceChip(
                        label: Text(
                          "0.75x",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2b0d0d),
                          ),
                        ),
                        selected: currentSpeed == 0.75,
                        selectedColor: Color(0xfff2d6d6),
                        onSelected: (selected) {
                          bloc?.add(SpeedChangedEvent(0.75));
                        },
                      ),
                      ChoiceChip(
                        label: Text(
                          "1.0x",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2b0d0d),
                          ),
                        ),
                        selected: currentSpeed == 1,
                        selectedColor: Color(0xfff2d6d6),
                        onSelected: (selected) {
                          bloc?.add(SpeedChangedEvent(1));
                        },
                      ),
                      ChoiceChip(
                        label: Text(
                          "1.25x",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2b0d0d),
                          ),
                        ),
                        selected: currentSpeed == 1.25,
                        selectedColor: Color(0xfff2d6d6),
                        onSelected: (selected) {
                          bloc?.add(SpeedChangedEvent(1.25));
                        },
                      ),
                      ChoiceChip(
                        label: Text(
                          "1.5x",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2b0d0d),
                          ),
                        ),
                        selected: currentSpeed == 1.5,
                        selectedColor: Color(0xfff2d6d6),
                        onSelected: (selected) {
                          bloc?.add(SpeedChangedEvent(1.5));
                        },
                      ),
                      ChoiceChip(
                        label: Text(
                          "2.0x",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2b0d0d),
                          ),
                        ),
                        selected: currentSpeed == 2,
                        selectedColor: Color(0xfff2d6d6),
                        onSelected: (selected) {
                          bloc?.add(SpeedChangedEvent(2));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsetsGeometry.only(
                  top: 8,
                  bottom: 10,
                  left: 20,
                  right: 20,
                ),
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(
                  color: Color(0xfff8f6f7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  spacing: 6,
                  children: [
                    Text(
                      "Información del audio",
                      style: TextStyle(
                        fontFamily: "DMSerif",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff2b0d0d),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //spacing: 26,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Estado",
                              style: TextStyle(
                                fontFamily: "DMSerif",
                                fontSize: 12,
                                color: Color(0xff6e3b3b),
                              ),
                            ),
                            Text(
                              currentState ? "Reproduciendo" : "En pausa",
                              style: TextStyle(
                                fontFamily: "DMSerif",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2b0d0d),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Duración",
                              style: TextStyle(
                                fontFamily: "DMSerif",
                                fontSize: 12,
                                color: Color(0xff6e3b3b),
                              ),
                            ),
                            Text(
                              timeFormat(currentDuration.inSeconds),
                              style: TextStyle(
                                fontFamily: "DMSerif",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2b0d0d),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Posición",
                              style: TextStyle(
                                fontFamily: "DMSerif",
                                fontSize: 12,
                                color: Color(0xff6e3b3b),
                              ),
                            ),
                            Text(
                              timeFormat(currentPosition.inSeconds),
                              style: TextStyle(
                                fontFamily: "DMSerif",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2b0d0d),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
