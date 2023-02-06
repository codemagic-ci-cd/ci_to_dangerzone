import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

abstract class StackedSpriteComponent extends PositionComponent {
  late SpriteBatch _batch;
  final String name;
  final Game game;
  double _stackAngle = 0;

  StackedSpriteComponent(this.game, this.name) : super(priority: 2);

  @override
  double get angle => _stackAngle;

  @override
  set angle(double a) {
    _stackAngle = a;
    _getBatch();
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    await _getBatch();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _batch.render(canvas);
  }

  void move(Vector2 delta) {
    position.add(delta / 4); // makes movements smaller, smoother, less jerky
  }

  Future<void> _getBatch() async {
    final sheetImg = await game.images.load('$name.png');
    _batch = await SpriteBatch.load('$name.png');
    const double spriteWidth = 16;
    final sliceCount = sheetImg.width ~/ spriteWidth;

    for (int i = 0; i < sliceCount; i++) {
      _batch.add(
        source: Rect.fromLTWH(spriteWidth * i, 0, spriteWidth, spriteWidth),
        offset: Vector2(0, -i.toDouble()),
        anchor: Vector2.all(spriteWidth / 2),
        rotation: _stackAngle * radians2Degrees,
      );
    }
  }
}
