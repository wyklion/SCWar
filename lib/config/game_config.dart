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
  static const Color tower = Color(0xFF20B2AA);
  static const Color towerMove = Color(0xFF48C9B0);
  static const Color towerMerge = Color(0xFF2ECC71);
  static const Color towerSwap = Color(0xFF008080);
  static const Color enemy = Color(0xFF3282b8);
  static const Color enemy2 = Color(0xFF0f4c75);
  static const Color bullet = Color(0xFFFF8A00);
  static const Color score = Color(0xFFFCF3CF);
  static const Color highScore = Color(0xFFf1f0cf);
  static const Color dialogTitle = Color(0xFF005B9A);
}

class TextStyleMap {
  static const TextStyle label = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1F4E79),
      shadows: [
        Shadow(
          blurRadius: 2,
          color: Color(0x88000000),
          offset: Offset(2, 2),
        )
      ]);
  static const TextStyle dataLabel = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6D7993));
  static const TextStyle data = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFD3E2F2));
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
