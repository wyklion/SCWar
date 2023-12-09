import 'package:flutter/material.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/utils/iconfont.dart';
import 'package:scwar/utils/number_util.dart';

class TestSwitchButton extends StatefulWidget {
  final SCWarGame game;
  const TestSwitchButton({super.key, required this.game});
  @override
  TestSwitchButtonState createState() => TestSwitchButtonState();
}

class TestSwitchButtonState extends State<TestSwitchButton> {
  bool enable = true;
  @override
  Widget build(BuildContext context) {
    enable = Config.testMode;
    double scale = widget.game.scale;
    return TextButton(
        // icon: Icon(
        //   size: 40 / scale,
        //   Iconfont.soundOn,
        //   color: enable ? Colors.white : const Color(0xFF848484),
        // ),
        onPressed: () {
          setState(() {
            game.changeTestMode(!enable);
          });
        },
        child: Text(
          'TEST',
          style: TextStyle(
            fontSize: 25 / scale,
            fontWeight: FontWeight.bold,
            color: enable ? Colors.white : const Color(0xFF848484),
          ),
        ));
  }
}

Widget makePlayButton(SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            game.gameManager.soundManager.playCick();
            game.start();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3292b8), // 按钮背景颜色
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(55 / scale),
            ),
            fixedSize: Size(260 / scale, 110 / scale),
            foregroundColor: const Color(0xFF4be4c5),
            textStyle: TextStyle(
              color: const Color(0xFFa7f2a7),
              fontSize: 80 / scale,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  blurRadius: 5,
                  color: Color(0xff003333),
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
          child: const Text('PLAY'),
        ),
      ],
    ),
  );
}

Widget makeLevelButton(SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: SizedBox(
      height: 300 / scale,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
            game.gameManager.soundManager.playCick();
            game.goToLevel();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4baea0), // 按钮背景颜色
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5 / scale),
            ),
            fixedSize: Size(180 / scale, 60 / scale),
            foregroundColor: const Color(0xFF7DCEA0),
            textStyle: TextStyle(
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
          child: const Text('LEVEL'),
        ),
      ),
    ),
  );
}

Widget makeHighScore(SCWarGame game) {
  double scale = game.scale;
  return Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
      height: 100 / scale,
      child: Column(
        children: [
          Text(
            'HighScore: ${NumberUtil.getScoreString(game.playerData.highScore)}',
            style: TextStyle(
              color: const Color(0xFFf1f0cf), //ColorMap.highScore,
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
  );
}

Widget buidlHomeOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  List<Widget> stacks = [];
  stacks.add(makePlayButton(game));
  if (game.localStorage.hasGame()) {
    stacks.add(Center(
      child: SizedBox(
        width: 200 / scale,
        height: 120 / scale,
        child: Align(
          alignment: Alignment.topRight,
          child: Text(
            'continue',
            style: TextStyle(
              color: Colors.white30,
              fontSize: 25 / scale,
            ),
          ),
        ),
      ),
    ));
  }
  stacks.add(makeLevelButton(game));
  stacks.add(makeHighScore(game));
  if (!Config.release) {
    stacks.add(
      Positioned(
        top: 100 / scale,
        right: 40 / scale,
        child: TestSwitchButton(game: game),
      ),
    );
  }
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Stack(children: stacks),
    ),
  );
}
