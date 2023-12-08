import 'dart:html';

import 'package:square_destroyer/full_screen/full_screen_initializer.dart';

FullScreenInitializer getInitializer() => WebFullScreenInitializer();

class WebFullScreenInitializer extends FullScreenInitializer {
  @override
  void initialize() {
    document.documentElement?.requestFullscreen();
  }
}
