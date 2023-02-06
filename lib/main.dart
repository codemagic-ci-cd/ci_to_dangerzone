import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'game_over_overlay.dart';
import 'game_overlay.dart';
import 'game_start_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CI Dangerzone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'FutilePro',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  late final CIDangerZone _game;

  @override
  void initState() {
    super.initState();
    _game = CIDangerZone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GameWidget(
          game: _game,
          overlayBuilderMap: <String, Widget Function(BuildContext, CIDangerZone)>{
            Overlays.start.name: (context, game) => GameStartOverlay(game),
            Overlays.end.name: (context, game) => GameOverOverlay(game),
            Overlays.game.name: (context, game) => GameOverlay(game),            
          },
          initialActiveOverlays: [Overlays.start.name],
        ),
      ),
    );
  }
}
