import 'dart:async';
import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:flutter/services.dart';
import 'package:square_destroyer/components/ball.dart';
import 'package:square_destroyer/components/cannon.dart';
import 'package:square_destroyer/components/score_board.dart';
import 'package:square_destroyer/components/target.dart';
import 'package:square_destroyer/components/timer_board.dart';
import 'package:square_destroyer/__experimental_inference/agent.dart';
import 'package:square_destroyer/utils/key_handler.dart';
import 'package:square_destroyer/overlays/overlays.dart';

class SquareDestroyerGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection {
  SquareDestroyerGame() : super();

  final keyHandler = KeyHandler();
  final targetGenerator = TargetGenerator();

  final cannon = Cannon();
  late final ScoreBoard scoreBoard;
  late final TimerBoard timeLeft;

  Ball? ball;

  @override
  bool get debugMode => false;

  bool get shouldShootBall => keyHandler.isSpacePressed && ball == null;

  final agent = Agent.instance;

  bool isOnInference = false;

  @override
  FutureOr<void> onLoad() async {
    add(cannon);
    await agent.initialize();
    camera.viewport.addAll([
      scoreBoard = ScoreBoard(),
      timeLeft = TimerBoard(
        onTimeSet: onTimeSet,
        position: Vector2(size.x - 30, 30),
      )
    ]);

    return super.onLoad();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    if (!isLoaded) return KeyEventResult.ignored;

    return keyHandler.handle(event, keysPressed);
  }

  @override
  void update(double dt) {
    if (shouldShootBall) shoot();
    if (targetGenerator.canGenerate) addTarget();
    if (!kIsWeb && !isOnInference) infer();
    super.update(dt);
  }

  void shoot() {
    add(
      ball = Ball(
        position: cannon.position,
        shotRadian: cannon.angle,
        onHit: onHit,
      )..removed.then((_) => ball = null),
    );
  }

  void onHit() => scoreBoard.gain();

  void addTarget() {
    add(targetGenerator.generate(camera.viewport.size.x));
  }

  void restart() {
    overlays.remove(OverlayKeys.SCORE_RESULT.name);
    scoreBoard.reset();

    camera.viewport.addAll([
      scoreBoard,
      timeLeft,
    ]);

    resumeEngine();
  }

  void onTimeSet() {
    overlays.add(OverlayKeys.SCORE_RESULT.name);

    ball?.removeFromParent();
    scoreBoard.removeFromParent();
    timeLeft.removeFromParent();

    pauseEngine();
  }

  /// This is for inference the next action
  /// Only works for io.
  Future<void> infer() async {
    final target = targetGenerator.targets.firstOrNull;
    if (target == null) return;
    final inferenceResult = await agent.infer(
      cannonAngle: cannon.angle,
      targetAngle: target.angle,
      targetCoordinates: target.position,
    );
    log("target angle: ${target.angle}, coord: ${target.position}");
    log("action: ${inferenceResult.action}");
  }
}
