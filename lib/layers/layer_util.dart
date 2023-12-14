import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scwar/game/game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget makeTextButton(SCWarGame game, String name, VoidCallback onClick,
    {Color color = const Color(0xFFF7E7CE)}) {
  double scale = game.scale;
  return TextButton(
    style: TextButton.styleFrom(
      foregroundColor: color,
      padding: const EdgeInsets.all(12.0),
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

Widget makeIconButton(BuildContext context, SCWarGame game, IconData icon,
    String name, VoidCallback onClick,
    {Color? color}) {
  double scale = game.scale;
  return ElevatedButton(
    onPressed: () {
      onClick();
    },
    style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0xFF3292b8), // 按钮背景颜色
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30 / scale),
        ),
        fixedSize: Size(200 / scale, 50 / scale)),
    // return FilledButton(
    //   onPressed: () {
    //     onClick();
    //   },
    child: SizedBox(
      width: 145 / scale,
      // height: 40 / scale,
      // padding: EdgeInsets.all(3.0 / scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30 / scale,
            color: Colors.white, // 图标颜色
          ),
          SizedBox(
            width: 100 / scale,
            child: AutoSizeText(
              textAlign: TextAlign.center,
              maxLines: 1,
              name,
              style:
                  TextStyle(color: Colors.white, fontSize: 30 / scale), // 文字颜色
            ),
          ),
        ],
      ),
    ),
  );

  // return IconButton(
  //   icon: Icon(
  //     size: 50 / scale,
  //     icon,
  //     color: Colors.white,
  //   ),
  //   onPressed: () {
  //     onClick();
  //   },
  // );
}
