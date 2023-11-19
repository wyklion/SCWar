import 'package:flutter/material.dart';
import 'package:scwar/game.dart';

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
            color: Color.fromARGB(255, 62, 205, 233),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Center(
                    child: Text(
                      'Paused',
                      style: TextStyle(fontSize: 30 / scale),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: TextStyle(fontSize: 30 / scale),
                          ),
                          onPressed: () {
                            game.restart();
                          },
                          child: const Text('Restart'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: TextStyle(fontSize: 30 / scale),
                          ),
                          onPressed: () {
                            game.home();
                          },
                          child: const Text('Home'),
                        ),
                        TextButton(
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
