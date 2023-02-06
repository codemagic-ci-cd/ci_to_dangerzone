import 'package:ci_dangerzone_app/game.dart';
import 'package:ci_dangerzone_app/race_track.dart';
import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final CIDangerZone game;

  const GameOverOverlay(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final String time = formatedTime(game.courseTime);
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 64),
            Text(
              "Game Over",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),
            Text(
              game.resultText,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),
            Text(
              "Time: $time",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 64),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                game.overlays.remove(Overlays.end.name);
                game.overlays.add(Overlays.start.name);
              },
              child: Text("Ok", style: Theme.of(context).textTheme.displayMedium),
            ),
          ],
        ),
      ),
    );
  }
}
