import 'stub.dart'
    if (dart.library.io) 'io_dummy.dart'
    if (dart.library.js) 'web_full_screen_initializer.dart'
    as full_screen_initializer;

abstract class FullScreenInitializer {
  static final _instance = full_screen_initializer.getInitializer();
  static FullScreenInitializer get instance => _instance;

  void initialize();
}
