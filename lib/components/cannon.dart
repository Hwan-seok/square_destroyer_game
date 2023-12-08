import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:square_destroyer/consts/priorities.dart';
import 'package:square_destroyer/mixins/mixins.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

class Cannon extends PolygonComponent
    with HasGameReference<SquareDestroyerGame>, Glowable, Snapshot {
  Cannon()
      : super(
          [
            Vector2(0, 0),
            Vector2(0, 50),
            Vector2(50, 50),
            Vector2(100, 40),
            Vector2(100, 10),
            Vector2(50, 0),
          ],
          anchor: Anchor.center,
          priority: Priorities.CANNON.value,
          angle: -pi / 2,
        );

  @override
  Color get color => Colors.green;

  @override
  BlurStyle get blurStyle => BlurStyle.outer;

  @override
  double get blurSigma => 30;

  @override
  void onGameResize(Vector2 size) {
    position = Vector2(
      game.camera.viewport.size.x / 2,
      game.camera.viewport.size.y -
          super.size.y -
          50 * game.parameters.gameSizeFactor,
    );
    scale = Vector2.all(game.parameters.gameSizeFactor);
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    rotate();
  }

  void rotate() {
    if (game.keyHandler.isLeftPressed || game.dragHandler.isLeftPressed) {
      angle = max(-pi, angle - pi / 40);
    } else if (game.keyHandler.isRightPressed ||
        game.dragHandler.isRightPressed) {
      angle = min(0, angle + pi / 40);
    }
  }
}
