import 'package:flutter/material.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/utils/number_util.dart';

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
            child: SizedBox(
              height: 100 / scale,
              child: Column(
                children: [
                  Text(
                    'HighScore: ${NumberUtil.getScoreString(game.gameManager.localStorage.getHighScore())}',
                    style: TextStyle(
                      color: ColorMap.highScore,
                      fontSize: 30 / scale,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Config.version,
                    style: TextStyle(
                      fontSize: 18 / scale,
                      color: const Color(0xFF535353),
                    ),
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
