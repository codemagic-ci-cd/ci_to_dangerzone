import 'package:ci_dangerzone_app/race_track.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'game.dart';
import 'stacked_sprite_component.dart';

class Player extends StackedSpriteComponent with CollisionCallbacks, HasGameRef<CIDangerZone> {
  final hitbox = CircleHitbox(radius: 10, anchor: Anchor.center);

  bool _pendingLap = false; // approx hitbox for our player stackedsprites

  Player(super.game, super.name);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    await add(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is! StartGrid) {
      game.endGame();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is StartGrid) {
      _pendingLap = true;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is StartGrid && _pendingLap) {
      _pendingLap = false;
      game.lap();
    } 
  }
}
