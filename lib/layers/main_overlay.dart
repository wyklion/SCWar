import 'package:flutter/material.dart';
import 'package:scwar/game.dart';

Widget buidlMainOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
      child: AspectRatio(
    aspectRatio: 9 / 16,
    child: Container(
      // color: const Color.fromARGB(255, 139, 104, 96),
      child: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16.0),
            textStyle: TextStyle(fontSize: 30 / scale),
          ),
          onPressed: () {
            game.start();
          },
          child: const Text('Start'),
        ),
      ),
    ),
  ));
}