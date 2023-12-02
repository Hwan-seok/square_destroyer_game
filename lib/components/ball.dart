import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:square_destroyer/components/target.dart';
import 'package:square_destroyer/consts/consts.dart';
import 'package:square_destroyer/mixins/mixins.dart';
import 'package:square_destroyer/consts/priorities.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<SquareDestroyerGame>, Glowable {
  final double shotRadian;
  final VoidCallback onHit;

  Ball({
    required this.shotRadian,
    required this.onHit,
    super.position,
  }) : super(
          radius: AppConst.BALL_RADIUS,
          priority: Priorities.BALL.value,
          anchor: Anchor.center,
        );

  @override
  Color get color => Colors.red;

  @override
  BlurStyle get blurStyle => BlurStyle.solid;

  @override
  double get blurSigma => 20;

  bool get isOutOfBounds =>
      x < 0 || y < 0 || x > game.size.x || y > game.size.y;

  @override
  Future<void> onLoad() {
    add(CircleHitbox(isSolid: true));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    final dx = cos(shotRadian) * AppConst.BALL_SPEED;
    final dy = sin(shotRadian) * AppConst.BALL_SPEED;
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
    if (other is! Target) return;

    onHit();
    removeFromParent();
  }
}
