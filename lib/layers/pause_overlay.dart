import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/layers/layer_util.dart';

class SoundSwitchButton extends StatefulWidget {
  final SCWarGame game;
  const SoundSwitchButton({Key? key, required this.game}) : super(key: key);

  @override
  SoundSwitchButtonState createState() => SoundSwitchButtonState();
}

class SoundSwitchButtonState extends State<SoundSwitchButton> {
  bool isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    isSoundOn = widget.game.gameManager.soundManager.soundOn;
    return makeTextButton(widget.game, isSoundOn ? 'Sound On' : 'Sound Off',
        () {
      widget.game.gameManager.setSoundOn(!isSoundOn);
      setState(() {
        isSoundOn = !isSoundOn;
      });
    }, color: isSoundOn ? const Color(0xFFF7E7CE) : const Color(0xFF444444));
    // return IconButton(
    //   icon: Icon(
    //     isSoundOn ? Icons.volume_up : Icons.volume_off,
    //     color: isSoundOn ? Colors.green : Colors.red,
    //   ),
    //   onPressed: () {
    //     setState(() {
    //       isSoundOn = !isSoundOn;
    //       widget.onToggle(isSoundOn);
    //     });
    //   },
    // );
  }
}

Widget buidlPauseOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        color: const Color.fromARGB(130, 0, 0, 0),
        child: Center(
          child: Container(
            width: 300 / scale,
            height: 400 / scale,
            color: const Color(0xFF7FB3D5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: SizedBox(
                    height: 100 / scale,
                    child: Center(
                      child: Text(
                        'Paused',
                        style: TextStyle(
                            color: const Color(0xFF5C5C5C),
                            fontSize: 30 / scale,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SoundSwitchButton(game: game),
                        makeTextButton(game, 'Restart', () {
                          game.gameManager.soundManager.playCick();
                          game.restart();
                        }),
                        makeTextButton(game, 'Home', () {
                          game.gameManager.soundManager.playCick();
                          game.home();
                        }),
                        makeTextButton(game, 'Resume', () {
                          game.gameManager.soundManager.playCick();
                          game.resume();
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
  );
}
