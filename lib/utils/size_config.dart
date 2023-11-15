import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../game_config.dart';

class SizeConfig {
  late Vector2 size;
  double baseLen = 20;
  SizeConfig(Vector2 size) {
    var w = size.x;
    var h = size.y - 100;
    var rate = 500 / 800;
    if (w / h > rate) {
      w = h * rate;
    } else {
      h = w / rate;
    }
    this.size = Vector2(w, h);
    baseLen = w / 8;
    GameConfig.size = this.size.clone();
    GameConfig.baseLen = baseLen;
    GameConfig.snapLenSquare = (baseLen / 2) * (baseLen / 2);
    log('originSize: $size, size ($w, $h) baseLen: $baseLen');
  }

  Vector2 getPrepareTowerPos() {
    return Vector2(size.x - baseLen, size.y - baseLen * 2);
  }

  Vector2 getTowerPos(int row, int column) {
    if (row == -1 && column == -1) {
      return getPrepareTowerPos();
    }
    return Vector2(30 + baseLen * column, size.y - 30 - baseLen * row);
  }

  Vector2 getEnemyPos(int row, int column) {
    return Vector2(30 + baseLen * column, 30 + baseLen * row);
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
