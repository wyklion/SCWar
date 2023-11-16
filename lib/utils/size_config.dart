import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../game_config.dart';

class SizeConfig {
  late Vector2 size;
  double baseLen = 70;
  SizeConfig(Vector2 gameSize) {
    size = GameConfig.size;
    log('originSize: $gameSize, size (${size.x}, ${size.y}) baseLen: $baseLen');
  }

  Vector2 getPrepareTowerPos() {
    return Vector2(
        size.x - baseLen - size.x / 2, size.y - baseLen * 2 - size.y / 2);
  }

  Vector2 getTowerPos(int row, int column) {
    if (row == -1 && column == -1) {
      return getPrepareTowerPos();
    }
    return Vector2(baseLen * 0.6 + baseLen * column - size.x / 2,
        size.y - baseLen * 0.6 - baseLen * row - size.y / 2);
  }

  Vector2 getEnemyPos(int row, int column) {
    return Vector2(baseLen * 0.6 + baseLen * column - size.x / 2,
        baseLen * 0.6 + baseLen * row - size.y / 2);
  }

  double getTowerEnemyDistance(int towerRow, int enemyRow) {
    var t = size.y - 30 - baseLen * towerRow;
    var e = 30 + baseLen * enemyRow;
    return t - e - baseLen;
  }

  (int, int)? findNearTowerPos(double x, double y) {
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < 5; j++) {
        var pos = getTowerPos(i, j);
        if (pos.distanceToSquared(Vector2(x, y)) < GameConfig.snapLenSquare) {
          return (i, j);
        }
      }
    }
    return null;
  }
}
