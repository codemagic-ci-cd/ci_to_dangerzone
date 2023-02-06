import 'package:ci_dangerzone_app/script_handler.dart';
import 'package:ci_dangerzone_app/script_loader.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flutter/painting.dart';

import 'game.dart';

class RaceTrack extends SpriteComponent {
  late final ScriptHandler scriptHandler;

  RaceTrack() : super(size: Vector2(925, 518));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('racetrack.png');

    scriptHandler = ScriptHandler(track: this, script: await loadScriptFromNetwork());
    scriptHandler.createObstacles();
  }

  Future<void> addObstacle(double x, double y, bool visible) async {
    if (visible) {
      await add(WitchesHat(position: Vector2(x, y)));
    }
  }
}

abstract class Obstacle extends SpriteComponent {
  Obstacle({super.position})
      : super(
          priority: 1,
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
  }
}

class WitchesHat extends Obstacle {
  final hitbox = CircleHitbox();

  WitchesHat({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('witches_hat.png');
    size = Vector2.all(32);
    add(hitbox);
  }
}

class StartGrid extends Obstacle {
  // want solid so we only get 1 collision end
  final hitbox = RectangleHitbox(isSolid: true);

  StartGrid({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('startgrid.png');
    size = Vector2.all(32)..scale(3);
    add(hitbox);
  }
}

class LapDisplay extends PositionComponent with HasGameRef<CIDangerZone> {
  int _lap = 0;
  late TextComponent _lapText = _buildLapText;

  TextComponent get _buildLapText => TextComponent(text: 'LAPS:${_lap < 0 ? 0 : _lap}', textRenderer: textPaint)
    ..anchor = Anchor.topCenter
    ..x = 90
    ..y = 40;

  TextPaint get textPaint => TextPaint(
        style: const TextStyle(
          fontSize: 48.0,
          fontFamily: 'FutilePro',
        ),
      );

  @override
  Future<void> onLoad() async {
    _lap = game.laps;

    add(_lapText);
    add(TimerText()..position = Vector2.all(5));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.laps != _lap) {
      _lap = game.laps;
      if (_lapText.isMounted) {
        remove(_lapText);
      }
      _lapText = _buildLapText;
      add(_lapText);
    }
  }
}

class TimerText extends TextComponent with HasGameRef<CIDangerZone> {
  TimerText()
      : super(
          text: "",
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 48.0,
              fontFamily: 'FutilePro',
            ),
          ),
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    

    if (game.laps < 0) {
      textRenderer.render(canvas, "Time: 00:00", Vector2(0, 0));
    } else {
      final double time = game.currentTime() - game.gameStartTime;
      
      textRenderer.render(canvas, "Time: ${formatedTime(time)}", Vector2(0, 0));
    }
  }
}

String formatedTime(double time) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");

  final ms = time.toString().split(".")[1].substring(0, 3);
  return "${twoDigits(time.round())}:$ms";
}
