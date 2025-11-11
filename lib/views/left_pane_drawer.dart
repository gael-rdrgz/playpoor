import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/blocs/player_state.dart';

import '../blocs/player_bloc.dart';
import '../blocs/player_load_states.dart';
import 'conf_modal.dart';

class LeftPaneDrawer extends StatelessWidget {
  final PlayerBloc? bloc;

  const LeftPaneDrawer({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayState>(
      bloc: bloc,
      builder: (context, state) {
        final bool isPlaying = state is PlayingState && state.isPlaying;
        return Container(
          color: Color(0xfff2e4e9),
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.only(bottom: 24, top: 24),
                child: Image.asset("assets/icon/icon.png"),
              ),
              ListTile(
                title: Text(
                  isPlaying ? "Pausar" : "Reanudar",
                  style: TextStyle(
                    fontFamily: "DMSerif",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xff2b0d0d),
                  ),
                ),
                onTap: () {
                  bloc?.add(PlayPauseEvent());
                },
              ),
              ListTile(
                title: Text(
                  "Anterior",
                  style: TextStyle(
                    fontFamily: "DMSerif",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xff2b0d0d),
                  ),
                ),
                onTap: () {
                  bloc?.add(PrevEvent());
                },
              ),
              ListTile(
                title: Text(
                  "Siguiente",
                  style: TextStyle(
                    fontFamily: "DMSerif",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xff2b0d0d),
                  ),
                ),
                onTap: () {
                  bloc?.add(NextEvent());
                },
              ),
              ListTile(
                title: Text(
                  "Configuraciones",
                  style: TextStyle(
                    fontFamily: "DMSerif",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xff2b0d0d),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfModal(bloc: bloc);
                    },
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Salir",
                  style: TextStyle(
                    fontFamily: "DMSerif",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff2b0d0d),
                  ),
                ),
                onTap: () {
                  exit(0);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
