import 'dart:isolate';

import 'package:square_destroyer/__experimental_inference/agent.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateInference {
  static const String _debugName = "TFLITE_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: _debugName,
    );
    _sendPort = await _receivePort.first;
  }

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }

// # i.set_tensor(input_details[0]["index"], np.array([11111], dtype=np.int32))
// # i.set_tensor(input_details[1]["index"], np.array([0.99], dtype=np.float32))
// # i.set_tensor(
// #     input_details[2]["index"], np.array([[4.0, 600.0, 0.0, 1.0]], dtype=np.float32)
// # )
// # i.set_tensor(input_details[3]["index"], np.array([10.0], dtype=np.float32))
  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final Message message in port) {
      final input = [
        1, // step_type
        0.99, // discount
        [
          message.cannonAngle,
          message.targetX,
          message.targetY,
          message.targetAngle,
        ], // observation
        10, // reward
      ];
      final output = {
        0: <int>[-1]
      };
      final interpreter = Interpreter.fromAddress(message.interpreterAddress);
      interpreter.runForMultipleInputs(input, output);
      final action = output[0]?[0] ?? 2;

      message.responsePort.send(InferenceResult(action));
    }
  }
}

class Message {
  int interpreterAddress;
  List<int> inputShape;
  List<int> outputShape;
  late SendPort responsePort;

  final double targetAngle;
  final double targetX;
  final double targetY;
  final double cannonAngle;

  Message({
    required this.interpreterAddress,
    required this.inputShape,
    required this.outputShape,
    required this.targetAngle,
    required this.targetX,
    required this.targetY,
    required this.cannonAngle,
  });
}
