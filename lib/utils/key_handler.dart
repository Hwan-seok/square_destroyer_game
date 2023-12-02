import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyHandler {
  bool get isSpacePressed => pressedKeys.contains(LogicalKeyboardKey.space);
  bool get isLeftPressed => pressedKeys.contains(LogicalKeyboardKey.arrowLeft);
  bool get isRightPressed =>
      pressedKeys.contains(LogicalKeyboardKey.arrowRight);

  final pressedKeys = <LogicalKeyboardKey>{};
  final availableKeys = <LogicalKeyboardKey>{
    LogicalKeyboardKey.space,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
  };

  KeyEventResult handle(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final acceptedKeys = keysPressed.intersection(availableKeys);

    pressedKeys.clear();
    pressedKeys.addAll(acceptedKeys);
    return KeyEventResult.handled;
  }
}
