import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/player_bloc.dart';
import '../blocs/player_load_states.dart';
import '../blocs/player_state.dart';

class Artist extends StatelessWidget {
  const Artist({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayState>(
      builder: (context, state) {
        final bloc = context.read<PlayerBloc>();
        String name = "", artist = "";
        if (state is PlayingState){
          name = bloc.canciones[state.currentIndex].title;
          artist = bloc.canciones[state.currentIndex].artist;
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "DMSerif",
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                artist,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "DMSerif",
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
