import 'package:flutter/material.dart';

import 'game.dart';
import 'vehicle_widget.dart';

class GameStartOverlay extends StatelessWidget {
  final CIDangerZone _game;
  const GameStartOverlay(this._game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          children: [
            Text(
              "CI to the Danger Zone",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Padding(padding: EdgeInsets.all(16)),
            MaterialButton(
              color: Colors.amberAccent,
              onPressed: () => _game.startGame(),
              child: Text('Start Game', style: Theme.of(context).textTheme.displayMedium),
            ),
            const SizedBox(
              height: 32,
            ),
            VehicleSelector(selectVehicle: (name) => _game.vehicle = name),
          ],
        ),
      ),
    );
  }
}
