import 'package:flutter/material.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/layers/layer_util.dart';
import 'package:scwar/utils/iconfont.dart';
import 'package:scwar/utils/number_util.dart';

Widget makeLevelButton(SCWarGame game, int level) {
  double scale = game.scale;
  return SizedBox(
    width: 70 / scale,
    height: 70 / scale,
    child: ElevatedButton(
      onPressed: () {
        game.gameManager.soundManager.playCick();
        game.start(level: level);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3F5D7D), // 按钮背景颜色
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5 / scale),
          ),
          fixedSize: Size(70 / scale, 70 / scale)),
      child: Text(
        '$level',
        style: TextStyle(color: Colors.white, fontSize: 20 / scale), // 文字颜色
      ),
    ),
  );
}

Widget makeLevels(SCWarGame game) {
  double scale = game.scale;
  double space = 20 / scale;
  List<Widget> column = [SizedBox(height: space)];
  for (var i = 0; i < 10; i++) {
    List<Widget> row = [];
    for (var j = 0; j < 5; j++) {
      row.add(makeLevelButton(game, i * 5 + j + 1));
      if (j < 4) {
        row.add(SizedBox(width: space));
      }
    }
    column.add(Expanded(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: row)));
    column.add(SizedBox(height: space));
  }
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: column);
}

Widget buidlLevelOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Column(children: [
        SizedBox(
          height: 100 / scale,
        ),
        SizedBox(
          height: 760 / scale,
          child: makeLevels(game),
        ),
        Expanded(
          child: Center(
            child: makeIconButton(game, Iconfont.home, 'Return', 10, () {
              game.gameManager.soundManager.playCick();
              game.goHome();
            }),
            // child: ElevatedButton(
            //   onPressed: () {
            //     game.gameManager.soundManager.playCick();
            //     game.goHome();
            //   },
            //   style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xFF3F5D7D), // 按钮背景颜色
            //       // padding: const EdgeInsets.symmetric(vertical: 10.0),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30 / scale),
            //       ),
            //       fixedSize: Size(200 / scale, 50 / scale)),
            //   child: Text(
            //     'RETURN',
            //     style: TextStyle(
            //         color: Colors.white, fontSize: 30 / scale), // 文字颜色
            //   ),
            // ),
          ),
        ),
      ]),
    ),
  );
}
