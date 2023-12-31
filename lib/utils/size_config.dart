import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../config/game_config.dart';

class SizeConfig {
  late Vector2 size;
  late double baseLen;
  late double edgeSize;
  late double edgeSize2;
  SizeConfig(Vector2 gameSize) {
    size = GameConfig.size;
    baseLen = GameConfig.baseBlockLen;
    edgeSize = baseLen * 0.5 + GameConfig.edge;
    edgeSize2 = GameConfig.edge;
    log('originSize: $gameSize, size (${size.x}, ${size.y}) baseLen: $baseLen');
  }

  Rect getBattleFieldRect() {
    return Rect.fromLTWH(edgeSize2 - size.x / 2, edgeSize2 - size.y / 2,
        baseLen * GameConfig.col, baseLen * (GameConfig.row + 2));
  }

  Rect getEnemyBgRect() {
    return Rect.fromLTWH(edgeSize2 - size.x / 2, edgeSize2 - size.y / 2,
        baseLen * GameConfig.col, baseLen * GameConfig.row);
  }

  Rect getTowerBgRect() {
    return Rect.fromLTWH(
        edgeSize2 - size.x / 2,
        size.y - edgeSize2 - baseLen * 2 - size.y / 2,
        baseLen * 5,
        baseLen * 2);
  }

  Vector2 getPrepareTowerPos() {
    return Vector2(size.x - baseLen - size.x / 2,
        size.y - edgeSize - baseLen / 2 - size.y / 2);
  }

  Vector2 getTowerPos(int row, int column) {
    if (row == -1 && column == -1) {
      return getPrepareTowerPos();
    }
    return Vector2(edgeSize + baseLen * column - size.x / 2,
        size.y - edgeSize - baseLen * row - size.y / 2);
  }

  Vector2 getEnemyPos(int row, int column, int body) {
    double x = edgeSize + baseLen * column - size.x / 2;
    double y = edgeSize + baseLen * row - size.y / 2;
    if (body == 2) {
      x += baseLen / 2;
      y += baseLen / 2;
    }
    return Vector2(x, y);
  }

  double getBoardX(int column) {
    double x = edgeSize + baseLen * column - size.x / 2;
    return x;
  }

  double getTopY() {
    return GameConfig.edge +
        GameConfig.baseBlockLen -
        GameConfig.baseLen -
        size.y / 2;
  }

  double getTowerEnemyDistance(int towerRow, int enemyRow) {
    var t = size.y - edgeSize - baseLen * towerRow;
    var e = edgeSize + baseLen * enemyRow;
    return t - e - baseLen;
  }

  (int, int)? findNearTowerPos(double x, double y) {
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < GameConfig.col; j++) {
        var pos = getTowerPos(i, j);
        if (pos.distanceToSquared(Vector2(x, y)) < GameConfig.snapLenSquare) {
          return (i, j);
        }
      }
    }
    return null;
  }
}
