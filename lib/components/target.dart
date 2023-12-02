import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:square_destroyer/components/ball.dart';
import 'package:square_destroyer/consts/consts.dart';
import 'package:square_destroyer/mixins/mixins.dart';
import 'package:square_destroyer/consts/priorities.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

class TargetGenerator {
  static const GENERATE_TERM_IN_MS = 1000;
  static const MAX_TARGET_COUNT = 10;

  final targets = <Target>{};

  final rand = Random();

  DateTime lastGeneratedAt = DateTime.now();

  bool get canGenerate => targets.length < MAX_TARGET_COUNT;

  Target generate(double maxX) {
    final bound = maxX / 4;
    assert(canGenerate);

    final target = Target(
      initialPosition: Vector2(
        rand.nextDouble() * (maxX / 2) + bound,
        0,
      ),
      shotRadian: rand.nextDouble() * pi,
    );
    targets.add(target);
    target.removed.then((_) => targets.remove(target));

    return target;
  }
}

class Target extends PolygonComponent
    with CollisionCallbacks, Glowable, HasGameReference<SquareDestroyerGame> {
  final double shotRadian;

  Target({
    required Vector2 initialPosition,
    required this.shotRadian,
    double size = AppConst.TARGET_SIZE,
  }) : super(
          [
            Vector2(0, 0),
            Vector2(0, size),
            Vector2(size, size),
            Vector2(size, 0),
          ],
          position: initialPosition,
          anchor: Anchor.center,
          priority: Priorities.TARGET.value,
        );

  @override
  BlurStyle get blurStyle => BlurStyle.outer;

  @override
  Color get color => Colors.yellow;

  @override
  int get blurFactor => 2;

  bool get isOutOfBounds =>
      x < 0 || y < 0 || x > game.size.x || y > game.size.y;

  @override
  Future<void> onLoad() {
    add(RectangleHitbox(isSolid: true));
    add(
      RotateEffect.by(
        2 * pi,
        InfiniteEffectController(
          RandomEffectController.uniform(
            LinearEffectController(0),
            min: 1,
            max: 2,
          ),
        ),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    final dx = cos(shotRadian) * AppConst.TARGET_SPEED;
    final dy = sin(shotRadian) * AppConst.TARGET_SPEED;
    position.setValues(position.x + dx, position.y + dy);

    if (isOutOfBounds) removeFromParent();
    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is! Ball) return;

    removeFromParent();
  }
}
