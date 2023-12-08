import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

class TimerBoard extends TextComponent
    with HasGameReference<SquareDestroyerGame> {
  static const GAME_DURATION = Duration(seconds: 60);
  static const GAME_SET = Duration.zero;
  static const FONT_SIZE = 42.0;

  final VoidCallback onTimeSet;

  DateTime gameUntil = DateTime.now();

  TimerBoard({
    required this.onTimeSet,
  }) : super(anchor: Anchor.topRight);

  @override
  void onMount() {
    reset();
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

  @override
  void update(double dt) {
    checkIfGameSet();
    super.update(dt);
  }

  void reset() {
    gameUntil = DateTime.now().add(GAME_DURATION);
  }

  void checkIfGameSet() {
    final timeLeft = gameUntil.difference(DateTime.now());
    text = '${timeLeft.inSeconds}s';

    if (timeLeft > GAME_SET) return;
    onTimeSet();
  }
}
