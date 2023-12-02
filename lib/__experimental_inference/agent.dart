import 'package:flame/game.dart';

import 'agent_stub.dart'
    if (dart.library.io) 'agent_io.dart'
    if (dart.library.js) 'agent_web.dart' as agent;

abstract class Agent {
  static final Agent _agent = agent.getAgent();

  static Agent get instance => _agent;

  Future<void> initialize();

  // inference camera frame
  Future<InferenceResult> infer({
    required double targetAngle,
    required Vector2 targetCoordinates,
    required double cannonAngle,
  });

  Future<void> close();
}

class InferenceResult {
  final int action;

  const InferenceResult(this.action);
}
