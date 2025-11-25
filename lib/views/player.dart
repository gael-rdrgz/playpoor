import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:playerbloc/blocs/player_bloc.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/services/database_helper.dart';
import 'package:playerbloc/views/artist.dart';
import 'package:playerbloc/views/botonera.dart';
import 'package:playerbloc/views/left_pane_drawer.dart';
import 'package:playerbloc/views/progress_slider.dart';
import 'package:playerbloc/views/swiper.dart';
import 'package:sqflite/sqflite.dart';

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
    AudioItem(
      assetPath: "allthat.mp3",
      title: "All that",
      artist: "Keyra",
      imagePath: "assets/allthat_colored.jpg",
    ),
    AudioItem(
      assetPath: "love.mp3",
      title: "Love",
      artist: "Gael",
      imagePath: "assets/love_colored.jpg",
    ),
    AudioItem(
      assetPath: "thejazzpiano.mp3",
      title: "Jazz Piano",
      artist: "Abram",
      imagePath: "assets/thejazzpiano_colored.jpg",
    ),
    AudioItem(
      assetPath: "hollow_knight.mp3",
      title: "Hollow Knight",
      artist: "Christopher Larkin",
      imagePath: "assets/hollow_knight.jpg",
    ),
    AudioItem(
      assetPath: "silksong.mp3",
      title: "Silksong",
      artist: "Christopher Larkin",
      imagePath: "assets/silksong.jpg",
    ),
    AudioItem(
      assetPath: "main_theme.mp3",
      title: "Main Theme",
      artist: "Gareth Coker",
      imagePath: "assets/orimain.jpg",
    ),
    AudioItem(
      assetPath: "elden_ring.mp3",
      title: "Elden Ring",
      artist: "Tsukasa Saitoh",
      imagePath: "assets/eldenring.png",
    ),
    AudioItem(
      assetPath: "fuentes_de_gael.mp3",
      title: "Fuentes De Ortiz",
      artist: "Ed Maverick",
      imagePath: "assets/ortiz.jpg",
    ),
  ];

  final dbHelper = DatabaseHelper.instance;

  final GlobalKey<SliderDrawerState> _drawerKey =
      GlobalKey<SliderDrawerState>();

  PageController? pageController;

  late final PlayerBloc bloc;

  @override
  void initState() {
    pageController = PageController(viewportFraction: .8);
    initSongs();
    super.initState();
  }

  bool isLoading = true;

  Future<void> initSongs() async {
    await dbHelper.loadAudioList(canciones);

    final cancionesBD = await dbHelper.readAll();

    setState(() {
      canciones
        ..clear()
        ..addAll(cancionesBD);

      bloc = PlayerBloc(audioPlayer: widget.audioPlayer, canciones: canciones);

      isLoading = false;
    });

    bloc.add(PlayerLoadEvent(0));
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

    if (!isLoading){
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
    } else {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xffa23e48),)),
      );
    }
  }

  @override
  void dispose() {
    pageController!.dispose();
    bloc.close();
    super.dispose();
  }
}
