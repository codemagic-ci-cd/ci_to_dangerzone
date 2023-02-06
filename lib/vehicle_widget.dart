import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'stacked_sprite_component.dart';

class VehicleSelector extends StatefulWidget {
  final Function(String) selectVehicle; 

  const VehicleSelector({super.key, required this.selectVehicle});

  @override
  State<VehicleSelector> createState() => _VehicleSelectorState();
}

class _VehicleSelectorState extends State<VehicleSelector> {
  int vehicleIndex = 0;

  @override
  void initState() {
    super.initState();
    updateVehicleSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 72.0,
          color: Theme.of(context).textTheme.displayMedium?.color,
          onPressed: () => setState(() {
            vehicleIndex = math.max(0, vehicleIndex - 1);
            updateVehicleSelection();
          }),
          icon: const Icon(Icons.arrow_back),
        ),
        AnimatedVehicleSelector(vehicleType: vehicles[vehicleIndex]),
        IconButton(
          iconSize: 72.0,
          color: Theme.of(context).textTheme.displayMedium?.color,
          onPressed: () => setState(() {
            vehicleIndex = math.min(vehicleIndex + 1, vehicles.length - 1);
            updateVehicleSelection();
          }),
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  void updateVehicleSelection() {
    widget.selectVehicle(vehicles[vehicleIndex]);
  }
}


class AnimatedVehicleSelector extends StatelessWidget {
  AnimatedVehicleSelector({super.key, required this.vehicleType});

  final String vehicleType;
  final _game = TransparentGame();

  @override
  Widget build(BuildContext context) {
    final preview = PlayerPreview(_game, vehicleType)..scale = Vector2.all(7);
    _game.add(preview);

    return Padding(
      padding: const EdgeInsets.only(top: 128, left: 96, right: 72),
      child: Center(
        child: SizedBox(
          height: 32,
          width: 32,
          child: GameWidget(
            game: _game,
          ),
        ),
      ),
    );
  }
}

class PlayerPreview extends StackedSpriteComponent {
  PlayerPreview(super.game, super.name);

  @override
  void update(double dt) {
    super.update(dt);
    angle += 0.0005;
  }
}

class TransparentGame extends FlameGame {
  TransparentGame({super.children});

  @override
  Color backgroundColor() => Colors.transparent;
}
