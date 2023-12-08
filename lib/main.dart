import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:square_destroyer/full_screen/full_screen_initializer.dart';
import 'package:square_destroyer/overlays/overlays.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool shouldRequestFullScreen = false;

  @override
  void initState() {
    if (kIsWeb) shouldRequestFullScreen = true;

    super.initState();
  }

  void requestFullScreen() {
    FullScreenInitializer.instance.initialize();
    setState(() => shouldRequestFullScreen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.black,
        child: Center(
          child: OrientationBuilder(
            builder: (context, orientation) {
              if (shouldRequestFullScreen) {
                return ElevatedButton(
                  onPressed: () => requestFullScreen(),
                  child: const Text("Go to Fullscreen"),
                );
              }

              return orientation == Orientation.portrait
                  ? const Text(
                      "This game only works in landscape mode.",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    )
                  : AspectRatio(
                      aspectRatio: 4 / 3,
                      child: GameWidget.controlled(
                        gameFactory: () => SquareDestroyerGame(),
                        overlayBuilderMap: overlayBuilderMappings,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
