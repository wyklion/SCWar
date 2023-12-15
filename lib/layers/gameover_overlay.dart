import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/layers/layer_util.dart';
import 'package:scwar/utils/iconfont.dart';
import 'package:scwar/utils/number_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                            AppLocalizations.of(context)!.continueTitle,
                            style: TextStyle(
                              color: ColorMap.dialogTitle,
                              fontSize: 40 / scale,
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
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            makeIconButton(context, game, Iconfont.end,
                                AppLocalizations.of(context)!.no,
                                color: const Color(0xFFb33030), () {
                              onFinish();
                            }),
                            SizedBox(height: 35 / scale),
                            makeIconButton(
                                context,
                                game,
                                Iconfont.video,
                                color: const Color(0xFF31aa75),
                                AppLocalizations.of(context)!.yes, () {
                              onReborn();
                            }),
                            AutoSizeText(
                              AppLocalizations.of(context)!.watchAd,
                              style: TextStyle(
                                color: const Color(0xFF555555),
                                fontSize: 20 / scale,
                              ),
                              maxLines: 1,
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
        AppLocalizations.of(context)!.gameOver,
        style: TextStyle(
          color: ColorMap.dialogTitle,
          fontSize: 40 / scale,
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
      AutoSizeText(
        '${AppLocalizations.of(context)!.score}: ${NumberUtil.getScoreString(game.gameManager.data.score)}',
        style: TextStyle(
          fontSize: 35 / scale,
          color: ColorMap.score,
        ),
        maxLines: 1,
      ),
      SizedBox(height: 5 / scale),
    ];
    if (game.gameManager.level == 0) {
      list.add(AutoSizeText(
        '${AppLocalizations.of(context)!.highScore}: ${NumberUtil.getScoreString(game.playerData.highScore)}',
        style: TextStyle(
          fontSize: 20 / scale,
          color: ColorMap.highScore,
        ),
        maxLines: 1,
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
                            makeIconButton(context, game, Iconfont.home,
                                AppLocalizations.of(context)!.home, () {
                              game.gameManager.soundManager.playCick();
                              game.goHome();
                            }),
                            SizedBox(height: 20 / scale),
                            makeIconButton(context, game, Iconfont.restart,
                                AppLocalizations.of(context)!.restart, () {
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
  bool rebornClicked = false;
  @override
  Widget build(BuildContext context) {
    if (!checkReborn && (Config.testMode || game.rewardedAd != null)) {
      return RebornComponent(
        game: game,
        onFinish: () {
          if (rebornClicked) {
            return;
          }
          game.gameManager.soundManager.playCick();
          setState(() {
            checkReborn = true;
            game.gameOver();
          });
        },
        onReborn: () async {
          if (game.rewardedAd == null || rebornClicked) {
            return;
          }
          setState(() {
            rebornClicked = true;
          });
          game.gameManager.soundManager.playCick();
          game.rewardedAd?.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
            // ignore: avoid_print
            print('Reward amount: ${rewardItem.amount}');
            game.reborn();
          });
        },
      );
    } else {
      game.gameOver();
      return GameOverComponent(game: game);
    }
  }
}

Widget buidlGameoverOverlay(BuildContext buildContext, SCWarGame game) {
  return GameFinishComponent(game: game);
}
