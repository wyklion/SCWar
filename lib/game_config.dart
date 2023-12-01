import 'package:flame/game.dart';
import 'package:flutter/material.dart';

enum EntityType {
  empty,
  enemy,
  energy,
  energyMultiply,
}

Map<int, (Color, double)> numberMap = {
  1: (Colors.white, 1),
  2: (Colors.white, 1),
  4: (Colors.white, 1),
  8: (Colors.white, 1),
  16: (Colors.white, 1),
  32: (Colors.white, 1),
  64: (Colors.white, 1),
  128: (Colors.white, 1),
  256: (Colors.white, 1),
  512: (Colors.white, 1),
  1024: (Colors.white, 1),
  2048: (Colors.white, 1),
  4096: (Colors.white, 1),
  8192: (Colors.white, 1),
  16384: (Colors.white, 0.9),
  32768: (Colors.white, 0.9),
  65536: (Colors.white, 0.9),
  131072: (Colors.white, 0.8),
};

final Map<String, Paint> paintMap = {
  'bg': Paint()..color = const Color(0xFF7FB3D5),
  'enemyBg': Paint()..color = const Color(0xFFD2E8E8),
  'towerBg': Paint()..color = const Color(0xFFA8DADC),
  'towerBlock': Paint()..color = const Color(0xFF9ED9D2),
  'energy': Paint()..color = const Color(0xFF9bcb3c),
  'energyMultiply': Paint()..color = const Color(0xFF7F00FF),
};

final class ColorMap {
  static Color tower = const Color(0xFF20B2AA);
  static Color towerMove = const Color(0xFF48C9B0);
  static Color towerMerge = const Color(0xFF2ECC71);
  static Color towerSwap = const Color(0xFF008080);
  static Color enemy = const Color(0xFF3282b8);
  static Color enemy2 = const Color(0xFF0f4c75);
  static Color bullet = const Color(0xFFFF8A00);
}

class GameConfig {
  static double fixedWidth = 540;
  static double fixedHeight = 960;
  static double edge = 12;
  static double baseBlockLen = 78;
  static double baseLen = 70;
  static double doubleBaseLen = 152;
  static Vector2 size = Vector2(540, 960);
  static double snapLenSquare = 39 * 39;
  static int row = 10;
  static int col = 5;
}
