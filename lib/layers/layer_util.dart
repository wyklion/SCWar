import 'package:flutter/material.dart';
import 'package:scwar/game.dart';

Widget makeTextButton(SCWarGame game, String name, VoidCallback onClick) {
  double scale = game.scale;
  return TextButton(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFFF7E7CE),
      padding: const EdgeInsets.all(16.0),
      shadowColor: const Color(0xFFf99f9f),
      textStyle: TextStyle(fontSize: 30 / scale),
    ),
    onPressed: () {
      onClick();
    },
    child: Text(
      name,
      style: const TextStyle(fontWeight: FontWeight.w500),
    ),
  );
  // return ClipRRect(
  //   borderRadius: BorderRadius.circular(4),
  //   child: Stack(children: <Widget>[
  //     Positioned.fill(
  //       child: Container(
  //         width: 200 / scale,
  //         decoration: const BoxDecoration(
  //           gradient: LinearGradient(
  //             colors: <Color>[Color(0xFF7FB3D5), Color(0xFFA8DADC)],
  //           ),
  //         ),
  //       ),
  //     ),
  //     TextButton(
  //       style: TextButton.styleFrom(
  //         foregroundColor: const Color(0xFFFFF1E0),
  //         padding: const EdgeInsets.all(16.0),
  //         shadowColor: Color(0xFFf99f9f),
  //         textStyle: TextStyle(fontSize: 30 / scale),
  //       ),
  //       onPressed: () {
  //         onClick();
  //       },
  //       child: Text(name),
  //     ),
  //   ]),
  // );
}
