import 'package:square_destroyer/overlays/score_result.dart';
import 'package:square_destroyer/square_destroyer_game.dart';

enum OverlayKeys {
  SCORE_RESULT,
}

final overlayBuilderMappings = {
  OverlayKeys.SCORE_RESULT.name: (_, SquareDestroyerGame game) =>
      ScoreResult(game: game),
};
