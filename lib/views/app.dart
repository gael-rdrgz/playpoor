import 'package:flutter/material.dart';
import 'package:playerbloc/views/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PlayPoor",
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff8f6f7),
        appBarTheme: AppBarTheme(backgroundColor: const Color(0xfff8f6f7)),
      ),
      home: const Home(),
    );
  }
}
