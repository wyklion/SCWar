import 'package:flutter/material.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/game/game_manager.dart';
import 'package:scwar/utils/iconfont.dart';

Widget buidlGameOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: EdgeInsets.all(10.0 / scale),
          child: IconButton(
            icon: Icon(
              size: 50 / scale,
              Iconfont.pause,
              color: const Color(0xFFF2F2F2),
            ),
            onPressed: () {
              if (game.gameManager.currentState != GameState.playerMove) {
                return;
              }
              game.gameManager.soundManager.playCick();
              game.pause();
            },
          ),
        ),
      ),
    ),
  );
}
