import 'package:flutter/material.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

class ScoreResult extends StatelessWidget {
  final SquareDestroyerGame game;
  const ScoreResult({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 400,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You made it!\nScore: ${game.hud.scoreBoard.score}",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => game.restart(),
                child: const Text("Restart"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
