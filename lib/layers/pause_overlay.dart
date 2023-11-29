import 'package:flutter/material.dart';
import 'package:scwar/game.dart';
import 'package:scwar/layers/layer_util.dart';

Widget buidlPauseOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        color: Color.fromARGB(130, 0, 0, 0),
        child: Center(
          child: Container(
            width: 300 / scale,
            height: 400 / scale,
            color: Color(0xFF7FB3D5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    height: 120 / scale,
                    child: Center(
                      child: Text(
                        'Paused',
                        style: TextStyle(
                            color: Color(0xFF5C5C5C),
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
                        makeTextButton(game, 'Restart', () {
                          game.restart();
                        }),
                        makeTextButton(game, 'Home', () {
                          game.home();
                        }),
                        makeTextButton(game, 'Resume', () {
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
