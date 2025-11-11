import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:playerbloc/views/player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  AudioPlayer? audioPlayer;
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer!.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Player(audioPlayer: audioPlayer!);
  }
}
