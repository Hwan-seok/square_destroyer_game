import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

class ScoreBoard extends TextBoxComponent
    with HasGameReference<SquareDestroyerGame> {
  static const SCORE_PER_MATCH = 100;
  static const FONT_SIZE = 30.0;

  int maximum = 0;
  int score = 0;

  ScoreBoard()
      : super(
          anchor: Anchor.topLeft,
          boxConfig: TextBoxConfig(
            margins: EdgeInsets.zero,
            maxWidth: 300,
          ),
        );

  @override
  void onMount() {
    _setText();
    super.onMount();
  }

  @override
  void onGameResize(Vector2 size) {
    textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: FONT_SIZE,
        color: Colors.white,
      ),
    );
    scale = game.parameters.gameScale;
    super.onGameResize(size);
  }

  void hit() {
    score += SCORE_PER_MATCH;
    maximum = max(maximum, score);
    _setText();
  }

  void reset() {
    score = 0;
    _setText();
  }

  void _setText() {
    text = '''
score: $score
max: $maximum''';
  }
}
