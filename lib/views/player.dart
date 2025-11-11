import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:playerbloc/blocs/player_bloc.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/views/artist.dart';
import 'package:playerbloc/views/botonera.dart';
import 'package:playerbloc/views/left_pane_drawer.dart';
import 'package:playerbloc/views/progress_slider.dart';
import 'package:playerbloc/views/swiper.dart';

import '../models/audio_item.dart';
import 'conf_modal.dart';

class Player extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const Player({super.key, required this.audioPlayer});

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  final List<AudioItem> canciones = [
    AudioItem("allthat.mp3", "All that", "Keyra", "assets/allthat_colored.jpg"),
    AudioItem("love.mp3", "Love", "Gael", "assets/love_colored.jpg"),
    AudioItem(
      "thejazzpiano.mp3",
      "Jazz Piano",
      "Abram",
      "assets/thejazzpiano_colored.jpg",
    ),
    AudioItem(
      "hollow_knight.mp3",
      "Hollow Knight",
      "Christopher Larkin",
      "assets/hollow_knight.jpg",
    ),
    AudioItem(
      "silksong.mp3",
      "Silksong",
      "Christopher Larkin",
      "assets/silksong.jpg",
    ),
    AudioItem(
      "main_theme.mp3",
      "Main Theme",
      "Gareth Coker",
      "assets/orimain.jpg",
    ),
    AudioItem(
      "elden_ring.mp3",
      "Elden Ring",
      "Tsukasa Saitoh",
      "assets/eldenring.png",
    ),
    AudioItem(
      "fuentes_de_gael.mp3",
      "Fuentes De Ortiz",
      "Ed Maverick",
      "assets/ortiz.jpg",
    ),
  ];

  final GlobalKey<SliderDrawerState> _drawerKey =
      GlobalKey<SliderDrawerState>();

  PageController? pageController;

  late final PlayerBloc bloc = PlayerBloc(
    audioPlayer: widget.audioPlayer,
    canciones: canciones,
  );

  @override
  void initState() {
    pageController = PageController(viewportFraction: .8);
    bloc.add(PlayerLoadEvent(0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //para la barra de estado del sistema adecuada
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return BlocProvider.value(
      value: bloc,

      child: Scaffold(
        body: SafeArea(
          top: true,
          child: SliderDrawer(
            key: _drawerKey,
            slider: LeftPaneDrawer(bloc: bloc),
            appBar: SliderAppBar(
              config: SliderAppBarConfig(
                title: Text(
                  "PlayPoor",
                  style: TextStyle(
                    color: Color(0xff2b0d0d),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "DMSerif",
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfModal(bloc: bloc);
                      },
                    );
                  },
                  icon: Icon(Icons.settings),
                  iconSize: 24,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Swiper(
                    pageController: pageController!,
                    audioList: canciones,
                    color: Color(0xffa23e48),
                    bloc: bloc,
                  ),
                  Artist(),
                  ProgressSlider(color: Color(0xffc84b64)),
                  Botonera(color: Color(0xffc84b64)),
                ],
              ),
            ),
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
