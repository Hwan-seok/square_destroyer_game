import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:square_destroyer/consts/consts.dart';

class TimerBoard extends TextComponent {
  final VoidCallback onTimeSet;

  DateTime gameUntil = DateTime.now();

  TimerBoard({
    required this.onTimeSet,
    required super.position,
  }) : super(
          anchor: Anchor.topRight,
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: AppConst.TIME_LEFT_FONT_SIZE,
              color: Colors.white,
            ),
          ),
        );

  @override
  void onMount() {
    reset();
    super.onMount();
  }

  @override
  void update(double dt) {
    checkIfGameSet();
    super.update(dt);
  }

  void reset() {
    gameUntil = DateTime.now().add(AppConst.GAME_DURATION);
  }

  void checkIfGameSet() {
    final timeLeft = gameUntil.difference(DateTime.now());
    text = '${timeLeft.inSeconds}s';

    if (timeLeft > AppConst.GAME_SET) return;
    onTimeSet();
  }
}
