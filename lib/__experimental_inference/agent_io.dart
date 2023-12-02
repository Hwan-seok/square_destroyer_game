import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flame/game.dart';
import 'package:square_destroyer/__experimental_inference/agent.dart';
import 'package:square_destroyer/__experimental_inference/isolate.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

Agent getAgent() => AgentImpl();

class AgentImpl extends Agent {
  static const modelPath = 'assets/models/model.tflite';

  late final Interpreter interpreter;
  late final IsolateInference isolateInference;
  late Tensor inputTensor;
  late Tensor outputTensor;

  // Load model
  Future<void> _loadModel() async {
    final options = InterpreterOptions();

    // Use XNNPACK Delegate
    // if (Platform.isAndroid) {
    //   options.addDelegate(XNNPackDelegate());
    // }

    // Use GPU Delegate
    // doesn't work on emulator
    // if (Platform.isAndroid) {
    //   options.addDelegate(GpuDelegateV2());
    // }

    // Use Metal Delegate
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // interpreter.resizeInputTensor(0, [1, 224, 224, 3]);
    interpreter.allocateTensors();

    inputTensor = interpreter.getInputTensors().first;

    // Get tensor output shape [1, 4]
    outputTensor = interpreter.getOutputTensors().first;

    log('Interpreter loaded successfully');
  }

  @override
  Future<void> initialize() async {
    await _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<InferenceResult> _inference(Message message) async {
    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort.send(
      message..responsePort = responsePort.sendPort,
    );
    var results = await responsePort.first;
    return results;
  }

  // inference camera frame
  @override
  Future<InferenceResult> infer({
    required double targetAngle,
    required Vector2 targetCoordinates,
    required double cannonAngle,
  }) async {
    var message = Message(
      interpreterAddress: interpreter.address,
      inputShape: inputTensor.shape,
      outputShape: outputTensor.shape,
      cannonAngle: cannonAngle,
      targetAngle: targetAngle,
      targetX: targetCoordinates.x,
      targetY: targetCoordinates.y,
    );
    return _inference(message);
  }

  @override
  Future<void> close() async {
    await isolateInference.close();
  }
}
