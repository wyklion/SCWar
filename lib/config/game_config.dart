import 'package:flame/game.dart';
import 'package:flutter/material.dart';

enum EntityType {
  empty,
  enemy,
  energy,
  energyMultiply,
}

final Map<String, Paint> paintMap = {
  'bg': Paint()..color = const Color(0xFF7FB3D5),
  'enemyBg': Paint()..color = const Color(0xFFD2E8E8),
  'towerBg': Paint()..color = const Color(0xFFA8DADC),
  'towerBlock': Paint()..color = const Color(0xFF98DACC),
  'preTowerBlock': Paint()..color = const Color(0xFF8FC3E5),
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
  static Color score = const Color(0xFFFFCD00);
  static Color highScore = const Color(0xFFF7E967);
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
