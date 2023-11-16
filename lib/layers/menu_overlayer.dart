import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scwar/game.dart';

Widget buidlMenuOverlayer(BuildContext buildContext, SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: Container(
        width: 300 / scale,
        height: 400 / scale,
        color: Colors.orange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                child: Center(
                    child: Text(
              'Paused',
              style: TextStyle(fontSize: 30 / scale),
            ))),
            Expanded(
              child: Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: TextStyle(fontSize: 30 / scale),
                  ),
                  onPressed: () {
                    game.resume();
                  },
                  child: const Text('Resume'),
                ),
              ),
            ),
          ],
        )),
  );
}
