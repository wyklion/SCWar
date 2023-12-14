import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/layers/layer_util.dart';
import 'package:scwar/utils/iconfont.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SoundSwitchButton extends StatefulWidget {
  final SCWarGame game;
  const SoundSwitchButton({super.key, required this.game});

  @override
  SoundSwitchButtonState createState() => SoundSwitchButtonState();
}

class SoundSwitchButtonState extends State<SoundSwitchButton> {
  bool isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    isSoundOn = widget.game.gameManager.soundManager.soundOn;
    double scale = widget.game.scale;
    // return IconButton(
    //   icon: Icon(
    //     size: 40 / scale,
    //     isSoundOn ? Iconfont.soundOn : Iconfont.soundOff,
    //     color: isSoundOn ? Colors.white : const Color(0xFF848484),
    //   ),
    //   onPressed: () {
    //     setState(() {
    //       widget.game.gameManager.setSoundOn(!isSoundOn);
    //       isSoundOn = !isSoundOn;
    //     });
    //   },
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            size: 40 / scale,
            isSoundOn ? Iconfont.soundOn : Iconfont.soundOff,
            color: isSoundOn ? Colors.white : const Color(0xFF848484),
          ),
          onPressed: () {
            setState(() {
              widget.game.gameManager.setSoundOn(!isSoundOn);
              isSoundOn = !isSoundOn;
            });
          },
        ),
        SizedBox(width: 40 / scale),
        Switch(
          value: isSoundOn,
          activeColor: const Color(0xFF4A90E2),
          inactiveTrackColor: Colors.grey,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onChanged: (value) {
            setState(() {
              isSoundOn = value;
              widget.game.gameManager.setSoundOn(isSoundOn);
            });
          },
        ),
      ],
    );
  }
}

Widget buidlPauseOverlay(BuildContext context, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        color: const Color.fromARGB(130, 0, 0, 0),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: UnconstrainedBox(
              child: IntrinsicWidth(
                child: Container(
                  width: 300 / scale,
                  // height: 400 / scale,
                  color: const Color(0xFF7FB3D5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20 / scale),
                      Text(
                        AppLocalizations.of(context)!.paused,
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
                      SoundSwitchButton(game: game),
                      SizedBox(height: 20 / scale),
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
                      SizedBox(height: 20 / scale),
                      makeIconButton(context, game, Iconfont.play,
                          AppLocalizations.of(context)!.resume, () {
                        game.gameManager.soundManager.playCick();
                        game.resume();
                      }, color: const Color(0xFF48C9B0)),
                      SizedBox(height: 20 / scale),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
