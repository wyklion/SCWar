import 'package:flutter/material.dart';
import 'package:scwar/game.dart';

Widget buidlHomeOverlay(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: AspectRatio(
      aspectRatio: 9 / 16,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: TextStyle(fontSize: 60 / scale),
              ),
              onPressed: () {
                game.start();
              },
              child: const Text('START'),
            ),
            const Text('v0.0.5'),
          ],
        ),
      ),
    ),
  );
}
