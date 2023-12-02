import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:square_destroyer/consts/consts.dart';

class ScoreBoard extends TextBoxComponent {
  ScoreBoard()
      : super(
          position: Vector2(30, 30),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: AppConst.SCORE_FONT_SIZE,
              color: Colors.white,
            ),
          ),
        );

  @override
  void onMount() {
    setText();
    super.onMount();
  }

  int maximum = 0;
  int score = 0;

  void gain() {
    score += AppConst.SCORE_PER_MATCH;
    maximum = max(maximum, score);
    setText();
  }

  void reset() {
    score = 0;
    setText();
  }

  void setText() {
    text = '''
score: $score
max: $maximum''';
  }
}
