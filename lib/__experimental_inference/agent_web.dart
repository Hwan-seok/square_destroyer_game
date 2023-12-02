import 'dart:developer';

import 'package:flame/game.dart';
import 'package:square_destroyer/__experimental_inference/agent.dart';

Agent getAgent() => AgentDummy();

class AgentDummy extends Agent {
  @override
  Future<void> initialize() async {
    log("WARNING: Platform not supported");
  }

  @override
  Future<InferenceResult> infer({
    required double targetAngle,
    required Vector2 targetCoordinates,
    required double cannonAngle,
  }) async {
    return const InferenceResult(0);
  }

  @override
  Future<void> close() async {}
}
