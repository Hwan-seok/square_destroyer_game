import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:square_destroyer/overlays/overlays.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.device.setLandscape();
  }

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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.black,
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: SizedBox(
              width: 1200,
              height: 800,
              child: GameWidget.controlled(
                gameFactory: () => SquareDestroyerGame(),
                overlayBuilderMap: overlayBuilderMappings,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
