import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:square_destroyer/components/score_board.dart';
import 'package:square_destroyer/components/timer_board.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

class Hud extends PositionComponent with HasGameReference<SquareDestroyerGame> {
  static const MARGIN = 30.0;

  final VoidCallback onTimeSet;

  late final ScoreBoard scoreBoard;
  late final TimerBoard timerBoard;

  Hud({
    required this.onTimeSet,
  }) {
    addAll([
      timerBoard = TimerBoard(onTimeSet: onTimeSet)..y = MARGIN,
      scoreBoard = ScoreBoard()..y = MARGIN,
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    timerBoard.position.x = size.x - MARGIN;
    scoreBoard.position.x = MARGIN;
    super.onGameResize(size);
  }

  void hitScore() => scoreBoard.hit();

  void resetScore() => scoreBoard.reset();
}
