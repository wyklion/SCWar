import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:scwar/layers/main_overlay.dart';
import 'package:scwar/layers/menu_overlay.dart';
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
              'pause': buidlMenuOverlay,
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
