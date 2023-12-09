import 'package:flutter/material.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/utils/iconfont.dart';

Widget makeLevelButton(SCWarGame game, int level, bool enable) {
  double scale = game.scale;
  bool passed = game.playerData.isLevelPassed(level);
  Widget content;
  if (passed) {
    content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$level',
          style: TextStyle(color: Colors.white, fontSize: 20 / scale), // 文字颜色
        ),
        Icon(
          Iconfont.ok,
          size: 20 / scale,
          color: Colors.white, // 图标颜色
        ),
      ],
    );
  } else {
    content = Text(
      '$level',
      style: TextStyle(
          color: const Color(0xFFf1f0cf), fontSize: 20 / scale), // 文字颜色
    );
  }
  return SizedBox(
    width: 70 / scale,
    height: 70 / scale,
    child: ElevatedButton(
      onPressed: () {
        if (!enable) {
          return;
        }
        game.gameManager.soundManager.playCick();
        game.start(level: level);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: !enable
              ? const Color(0xFF4b5d67)
              : passed
                  ? const Color(0xFF248888)
                  : const Color(0xFF31aa75),
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5 / scale),
          ),
          fixedSize: Size(70 / scale, 70 / scale)),
      child: content,
    ),
  );
}

Widget makeLevels(SCWarGame game) {
  double scale = game.scale;
  double space = 20 / scale;
  List<Widget> column = [SizedBox(height: space)];
  bool enable = true;
  for (var i = 0; i < 10; i++) {
    List<Widget> row = [];
    for (var j = 0; j < 5; j++) {
      int level = i * 5 + j + 1;
      bool passed = game.playerData.isLevelPassed(level);
      row.add(makeLevelButton(game, i * 5 + j + 1, Config.testMode || enable));
      if (!passed) {
        enable = false;
      }
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
            child: Center(
              child: Text(
                'LEVEL',
                style: TextStyle(
                  color: const Color(0xFF7DCEA0),
                  fontSize: 50 / scale,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      blurRadius: 3,
                      color: Color(0xff003333),
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
              ),
            )),
        SizedBox(
          height: 760 / scale,
          child: makeLevels(game),
        ),
        Expanded(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                game.gameManager.soundManager.playCick();
                game.goHome();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4baea0), // 按钮背景颜色
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30 / scale),
                  ),
                  fixedSize: Size(200 / scale, 50 / scale)),
              child: SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconfont.back,
                      size: 30 / scale,
                      color: Colors.white, // 图标颜色
                    ),
                    SizedBox(width: 10 / scale), // 间距
                    Text(
                      'Return',
                      style: TextStyle(
                          color: Colors.white, fontSize: 30 / scale), // 文字颜色
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    ),
  );
}
