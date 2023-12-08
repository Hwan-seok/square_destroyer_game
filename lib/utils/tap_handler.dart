import 'package:flame/events.dart';

class TapHandler {
  bool isTapPressed = false;

  void handleTap() => isTapPressed = true;

  void removeTap() => isTapPressed = false;
}

enum _DragDirection {
  LEFT,
  RIGHT,
}

class DragHandler {
  _DragDirection? _dragDirection;

  bool get isLeftPressed => _dragDirection == _DragDirection.LEFT;
  bool get isRightPressed => _dragDirection == _DragDirection.RIGHT;

  void handlerDragUpdate(DragUpdateEvent event) {
    if (event.delta.x > 0) {
      _dragDirection = _DragDirection.RIGHT;
    } else {
      _dragDirection = _DragDirection.LEFT;
    }
  }

  void handleDragEnd() => _dragDirection = null;
}
