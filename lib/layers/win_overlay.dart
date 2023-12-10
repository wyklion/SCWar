import 'package:flutter/material.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/layers/layer_util.dart';
import 'package:scwar/utils/iconfont.dart';
import 'package:scwar/utils/number_util.dart';

Widget buidlWinOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  List<Widget> list = [
    Text(
      'Level ${game.gameManager.level} complete !',
      style: TextStyle(
          color: const Color(0xFF3B5998),
          fontSize: 30 / scale,
          fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 20 / scale),
    Text(
      'Score: ${NumberUtil.getScoreString(game.gameManager.data.score)}',
      style: TextStyle(
        fontSize: 35 / scale,
        color: ColorMap.score,
      ),
    ),
    SizedBox(height: 5 / scale),
  ];
  List<Widget> buttons = [
    makeIconButton(game, Iconfont.home, 'Home', 30, () {
      game.gameManager.soundManager.playCick();
      game.goHome();
    })
  ];
  if (game.gameManager.level == 0) {
    list.add(Text(
      'High Score: ${NumberUtil.getScoreString(game.playerData.highScore)}',
      style: TextStyle(
        fontSize: 25 / scale,
        color: ColorMap.highScore,
      ),
    ));
  } else {
    if (game.gameManager.level < 50) {
      buttons.add(SizedBox(height: 20 / scale));
      buttons.add(makeIconButton(
          game, Iconfont.next, 'Level ${game.gameManager.level + 1}', 15, () {
        game.gameManager.soundManager.playCick();
        game.nextLevel();
      }));
    }
  }
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        color: const Color.fromARGB(130, 0, 0, 0),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 300 / scale,
              height: 400 / scale,
              color: const Color(0xFF7FB3D5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 200 / scale,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: list,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: buttons,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}