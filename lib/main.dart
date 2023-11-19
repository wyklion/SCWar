import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:scwar/layers/gameover_overlay.dart';
import 'package:scwar/layers/main_overlay.dart';
import 'package:scwar/layers/pause_overlay.dart';
import 'game.dart';

class SpaceShooterGame extends FlameGame {}

void main() {
  runApp(const AppWidget());
  // runApp(GameWidget(game: SCWarGame()));
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          color: Colors.blueGrey,
          child: GameWidget(
            game: SCWarGame(),
            overlayBuilderMap: const {
              'main': buidlMainOverlay,
              'pause': buidlPauseOverlay,
              'gameover': buidlGameoverOverlay,
            },
          ),
        )),
        Container(
          height: 80,
          color: Colors.blueGrey,
        ),
      ],
    );
  }
}
