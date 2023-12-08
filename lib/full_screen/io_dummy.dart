import 'package:square_destroyer/full_screen/full_screen_initializer.dart';

FullScreenInitializer getInitializer() => DummyScreenInitializer();

class DummyScreenInitializer extends FullScreenInitializer {
  @override
  void initialize() {}
}
