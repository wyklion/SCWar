import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'game.dart';

class SpaceShooterGame extends FlameGame {}

void main() {
  runApp(GameWidget(game: SCWarGame()));
}
