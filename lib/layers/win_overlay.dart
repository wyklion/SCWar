import 'package:flutter/material.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/layers/layer_util.dart';
import 'package:scwar/utils/iconfont.dart';
import 'package:scwar/utils/number_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buidlWinOverlay(BuildContext context, SCWarGame game) {
  double scale = game.scale;
  List<Widget> list = [
    Text(
      'Level ${game.gameManager.level} complete !',
      style: TextStyle(
        color: ColorMap.dialogTitle,
        fontSize: 32 / scale,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 2 / scale,
            color: const Color(0xfff8f8f8),
            offset: Offset(2 / scale, 2 / scale),
          ),
        ],
      ),
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
    makeIconButton(
        context, game, Iconfont.home, AppLocalizations.of(context)!.home, () {
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
      buttons.add(makeIconButton(context, game, Iconfont.next,
          '${AppLocalizations.of(context)!.level} ${game.gameManager.level + 1}',
          () {
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
