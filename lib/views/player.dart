import 'package:audioplayers/src/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerbloc/blocs/player_bloc.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/views/artist.dart';
import 'package:playerbloc/views/botonera.dart';
import 'package:playerbloc/views/progress_slider.dart';
import 'package:playerbloc/views/swiper.dart';

import '../models/audio_item.dart';

class Player extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const Player({Key? key, required this.audioPlayer}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final List<AudioItem> canciones = [
    AudioItem("allthat.mp3", "All that", "Keyra", "assets/allthat_colored.jpg"),
    AudioItem("love.mp3", "Love", "Gael", "assets/love_colored.jpg"),
    AudioItem(
      "thejazzpiano.mp3",
      "Jazz Piano",
      "Abram",
      "assets/thejazzpiano_colored.jpg",
    ),
  ];

  Color? wormColor;
  PageController? pageController;

  late final PlayerBloc bloc = PlayerBloc(
    audioPlayer: widget.audioPlayer,
    canciones: canciones,
  );

  @override
  void initState() {
    wormColor = Color(0xffda1cd2);
    pageController = PageController(viewportFraction: .8);
    bloc.add(PlayerLoadEvent(0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Swiper(
                pageController: pageController!,
                audioList: canciones,
                color: wormColor!,
                bloc: bloc,
              ),
              Artist(),
              ProgressSlider(color: Colors.pink),
              Botonera(color: Colors.pink),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController!.dispose();
    bloc.close();
    super.dispose();
  }
}
