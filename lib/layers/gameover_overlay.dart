import 'package:flutter/material.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/layers/layer_util.dart';
import 'package:scwar/utils/iconfont.dart';
import 'package:scwar/utils/number_util.dart';

class RebornComponent extends StatelessWidget {
  final SCWarGame game;
  final VoidCallback onFinish;
  final VoidCallback onReborn;
  const RebornComponent({
    super.key,
    required this.game,
    required this.onFinish,
    required this.onReborn,
  });
  @override
  Widget build(BuildContext context) {
    double scale = game.scale;
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
                        height: 140 / scale,
                        child: Center(
                          child: Text(
                            'Continue?',
                            style: TextStyle(
                                color: const Color(0xFF003f5c),
                                fontSize: 35 / scale,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            makeIconButton(game, Iconfont.end, 'No', 30,
                                color: const Color(0xFFb33030), () {
                              onFinish();
                            }),
                            SizedBox(height: 50 / scale),
                            makeIconButton(
                                game,
                                Iconfont.video,
                                color: Config.testMode
                                    ? const Color(0xFF31aa75)
                                    : Colors.grey,
                                'Yes',
                                20, () {
                              onReborn();
                            }),
                            Text(
                              'Watch video ad.',
                              style: TextStyle(
                                color: const Color(0xFF555555),
                                fontSize: 20 / scale,
                              ),
                            )
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
      ),
    );
  }
}

class GameOverComponent extends StatelessWidget {
  final SCWarGame game;
  const GameOverComponent({super.key, required this.game});
  @override
  Widget build(BuildContext context) {
    double scale = game.scale;
    List<Widget> list = [
      Text(
        'GameOver',
        style: TextStyle(
            color: const Color(0xFF003f5c),
            fontSize: 35 / scale,
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
    if (game.gameManager.level == 0) {
      list.add(Text(
        'High Score: ${NumberUtil.getScoreString(game.playerData.highScore)}',
        style: TextStyle(
          fontSize: 25 / scale,
          color: ColorMap.highScore,
        ),
      ));
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
                          children: [
                            makeIconButton(game, Iconfont.home, 'Home', 30, () {
                              game.gameManager.soundManager.playCick();
                              game.goHome();
                            }),
                            SizedBox(height: 20 / scale),
                            makeIconButton(
                                game, Iconfont.restart, 'Restart', 15, () {
                              game.gameManager.soundManager.playCick();
                              game.restart();
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
      ),
    );
  }
}

class GameFinishComponent extends StatefulWidget {
  final SCWarGame game;
  const GameFinishComponent({super.key, required this.game});
  @override
  GameFinishComponentState createState() => GameFinishComponentState();
}

class GameFinishComponentState extends State<GameFinishComponent> {
  bool checkReborn = false;
  bool reborning = false;
  @override
  Widget build(BuildContext context) {
    if (!checkReborn) {
      return RebornComponent(
        game: game,
        onFinish: () {
          if (reborning) {
            return;
          }
          game.gameManager.soundManager.playCick();
          setState(() {
            checkReborn = true;
            game.gameOver();
          });
        },
        onReborn: () async {
          if (reborning) {
            return;
          }
          setState(() {
            reborning = true;
          });
          game.gameManager.soundManager.playCick();
          bool reborned = await game.reborn();
          if (!reborned) {
            setState(() {
              reborning = false;
            });
          }
        },
      );
    } else {
      return GameOverComponent(game: game);
    }
  }
}

Widget buidlGameoverOverlay(BuildContext buildContext, SCWarGame game) {
  return GameFinishComponent(game: game);
}
