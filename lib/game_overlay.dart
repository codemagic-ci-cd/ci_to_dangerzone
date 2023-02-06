import 'package:ci_dangerzone_app/game.dart';
import 'package:flutter/material.dart';

class GameOverlay extends StatelessWidget {
  final CIDangerZone game;

  const GameOverlay(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    // end game button for easier dev/debugging
    // return IconButton(
    //   icon: const Icon(Icons.dangerous),
    //   onPressed: () => game.endGame(),
    // );
    return const SizedBox();
  }
}
