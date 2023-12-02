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
                foregroundColor: const Color(0xFFa7f2a7),
                padding: const EdgeInsets.all(16.0),
                textStyle: TextStyle(
                    fontSize: 80 / scale, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                game.start();
              },
              child: const Text('PLAY'),
            ),
            const Text(
              'v0.0.7',
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    ),
  );
}
