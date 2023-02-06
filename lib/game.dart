// ignore_for_file: avoid_print

import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

import 'player.dart';
import 'race_track.dart';
import 'stacked_sprite_component.dart';


const vehicles = ['BlueCar', 'YellowCar', 'GreenBigCar', 'RedMotorcycle', 'WhiteMotorcycle'];

enum Overlays { start, end, game }

class CIDangerZone extends FlameGame with HasKeyboardHandlerComponents, HasDraggableComponents, HasCollisionDetection {
  String _vehicleName = vehicles[0];

  StackedSpriteComponent? playerOne;
  RaceTrack _raceTrack = RaceTrack();
  LapDisplay _lapDisplay = LapDisplay();
  StartGrid _startGrid = StartGrid(position: Vector2(180, 350));

  int _lapCount = -1;

  double _gameTimer = 0;

  double get gameStartTime => _gameTimer;

  // first time past we count that first lap started
  int get laps => _lapCount;

  set vehicle(String name) => _vehicleName = name;

  String resultText = "";
  double courseTime = 0;
 
  CIDangerZone({super.children}) {
    initializeGameStart();
  }

  void startGame() {
    initializeGameStart();
    overlays.remove(Overlays.start.name);
    overlays.add(Overlays.game.name);
  }

  void initializeGameStart() {
    if (playerOne != null && playerOne!.isMounted) {
      remove(playerOne!);
    }
    if (_raceTrack.isMounted) {
      remove(_raceTrack);
    }
    if (_lapDisplay.isMounted) {
      remove(_lapDisplay);
    }
    _lapCount = -1;

    playerOne = Player(this, _vehicleName)
      ..scale = Vector2.all(4)
      ..position = Vector2(120, 400); //starting position of player
    add(playerOne!);
    _raceTrack = RaceTrack();
    add(_raceTrack);
    _lapDisplay = LapDisplay();
    add(_lapDisplay);
    _startGrid = StartGrid(position: Vector2(180, 350));
    add(_startGrid);  
  }

  void lap() {
    _lapCount++;
    print("LAP! $_lapCount");
    if (_lapCount == 0) {
      _gameTimer = currentTime();
    }
    if (_lapCount > 3) {
      endGame(win: true);
    }
  }

  void endGame({bool win = false}) {
    playerOne?.removeFromParent();
    _raceTrack.removeFromParent();
    _startGrid.removeFromParent();
    _lapDisplay.removeFromParent();

    courseTime = currentTime() - _gameTimer;
    _gameTimer = 0;
    
    overlays.remove(Overlays.game.name);
    if (win) {
      resultText = "🏆 FINISHED 🏆";
    } else {
      resultText = "⚠️ CRASHED ⚠️";
    }    
    overlays.add(Overlays.end.name);
  }

  @override
  Future<void> onLoad() async {
    // NA for now
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    final evtX = event.canvasPosition.x;
    final evtY = event.canvasPosition.y;

    final player = playerOne;

    if (player == null) {
      return;
    }

    player.angle = math.atan2(evtY - player.position.y, evtX - player.position.x) * degrees2Radians;

    final delta = Vector2(evtX - player.x, evtY - player.y);
    player.move(delta);
  }
}
