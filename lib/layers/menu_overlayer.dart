import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scwar/game.dart';

Widget buidlMenuOverlayer(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: Container(
        width: 100,
        height: 100,
        color: Colors.orange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Paused'),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: TextStyle(fontSize: 40 / scale),
              ),
              onPressed: () {
                game.resume();
              },
              child: const Text('Resume'),
            ),
          ],
        )),
  );
}
