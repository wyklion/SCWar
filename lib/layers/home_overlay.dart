import 'package:flutter/material.dart';
import 'package:scwar/game.dart';

Widget buidlHomeOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFa7f2a7),
                    padding: const EdgeInsets.all(16.0),
                    textStyle: TextStyle(
                      fontSize: 80 / scale,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          blurRadius: 7,
                          color: Color(0xff003333),
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    game.gameManager.soundManager.playCick();
                    game.start();
                  },
                  child: const Text('PLAY'),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100 / scale,
              child: Column(
                children: [
                  Text(
                    'HighScore: ${game.gameManager.localStorage.getHighScore() ?? 0}',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 248, 229, 13),
                      fontSize: 30 / scale,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'v0.0.9',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
