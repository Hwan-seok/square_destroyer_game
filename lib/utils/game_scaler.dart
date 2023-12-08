import 'package:flame/game.dart';

class GameScaler {
  GameScaler();

  double _gameSizeFactor = 1.0;

  double get gameSizeFactor => _gameSizeFactor;
  Vector2 get gameScale => Vector2.all(_gameSizeFactor);

  void setFactor(double gameWidth) {
    _gameSizeFactor = gameWidth / 1200;
  }
}
