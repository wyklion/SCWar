import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:scwar/layers/gameover_overlay.dart';
import 'package:scwar/layers/home_overlay.dart';
import 'package:scwar/layers/pause_overlay.dart';
import 'game/game.dart';

class SpaceShooterGame extends FlameGame {}

void main() {
  var app = const AppWidget();
  runApp(app);
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
              'main': buidlHomeOverlay,
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
