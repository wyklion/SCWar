import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:scwar/layers/menu_overlayer.dart';
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
          color: Colors.grey,
          child: GameWidget(
            game: SCWarGame(),
            overlayBuilderMap: const {'pause': buidlMenuOverlayer},
          ),
        )),
        Container(
          height: 80,
          color: Colors.grey,
        ),
      ],
    );
  }
}
