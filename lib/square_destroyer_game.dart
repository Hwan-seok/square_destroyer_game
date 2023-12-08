import 'dart:async';
import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:flutter/services.dart';
import 'package:square_destroyer/__experimental_inference/agent.dart';
import 'package:square_destroyer/components/ball.dart';
import 'package:square_destroyer/components/cannon.dart';
import 'package:square_destroyer/components/hud.dart';
import 'package:square_destroyer/components/target.dart';
import 'package:square_destroyer/overlays/overlays.dart';
import 'package:square_destroyer/utils/game_scaler.dart';
import 'package:square_destroyer/utils/key_handler.dart';
import 'package:square_destroyer/utils/tap_handler.dart';

class SquareDestroyerGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection, DragCallbacks, TapCallbacks {
  SquareDestroyerGame() : super();

  final parameters = GameScaler();

  final keyHandler = KeyHandler();
  final tapHandler = TapHandler();
  final dragHandler = DragHandler();

  final targetGenerator = TargetGenerator();

  final cannon = Cannon();

  late final hud = Hud(onTimeSet: onTimeSet);
  Ball? ball;

  @override
  bool get debugMode => false;

  bool get shouldShootBall =>
      (keyHandler.isSpacePressed || tapHandler.isTapPressed) && ball == null;

  final agent = Agent.instance;

  bool isOnInference = false;

  @override
  FutureOr<void> onLoad() async {
    add(cannon);
    camera.viewport.add(hud);
    await agent.initialize();

    add(FpsTextComponent());

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
  void onTapUp(TapUpEvent event) => tapHandler.handleTap();

  @override
  void onDragUpdate(DragUpdateEvent event) =>
      dragHandler.handlerDragUpdate(event);

  @override
  void onDragCancel(DragCancelEvent event) {
    dragHandler.handleDragEnd();
    super.onDragCancel(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    dragHandler.handleDragEnd();
    super.onDragEnd(event);
  }

  @override
  void update(double dt) {
    if (shouldShootBall) shoot();
    if (targetGenerator.canGenerate) addTarget();
    if (!kIsWeb && !isOnInference) infer();
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    parameters.setFactor(size.x);
    super.onGameResize(size);
  }

  void shoot() {
    tapHandler.removeTap();
    add(
      ball = Ball(
        position: cannon.position,
        shotRadian: cannon.angle,
        onHit: hud.hitScore,
      )..removed.then((_) => ball = null),
    );
  }

  void addTarget() {
    add(
      targetGenerator.generate(
        camera.viewport.size.x,
      ),
    );
  }

  void restart() {
    overlays.remove(OverlayKeys.SCORE_RESULT.name);

    hud.resetScore();
    camera.viewport.add(hud);

    resumeEngine();
  }

  void onTimeSet() {
    overlays.add(OverlayKeys.SCORE_RESULT.name);

    ball?.removeFromParent();
    hud.removeFromParent();

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
