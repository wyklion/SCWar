import 'package:flutter/material.dart';
import 'package:scwar/game.dart';
import 'package:scwar/layers/layer_util.dart';

Widget buidlGameoverOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        color: const Color.fromARGB(130, 0, 0, 0),
        child: Center(
          child: Container(
            width: 300 / scale,
            height: 400 / scale,
            color: const Color(0xFF7FB3D5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: SizedBox(
                    height: 120 / scale,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'GameOver',
                            style: TextStyle(
                              fontSize: 30 / scale,
                              color: const Color(0xFF5C5C5C),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Score: ${game.gameManager.score}',
                            style: TextStyle(
                              fontSize: 25 / scale,
                              color: const Color(0xFFFC5C5C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        makeTextButton(game, 'Restart', () {
                          game.restart();
                        }),
                        makeTextButton(game, 'Home', () {
                          game.home();
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}