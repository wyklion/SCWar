import 'dart:math' as math;

import 'package:scwar/game_config.dart';

import '../game_manager.dart';

class Generator {
  GameManager gameManager;
  int _base = 1;
  List<List<int>> queue = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0]
  ];
  final math.Random _random = math.Random();
  Generator(this.gameManager);

  void _refreshBase() {
    double power = gameManager.towerPower / 2;
    while (_base < power) {
      _base *= 2;
    }
  }

  int getNextEnemyValue() {
    int r = _random.nextInt(3);
    int result = _base * math.pow(2, r).toInt();
    return result;
  }

  int getNextEnegyValue() {
    int a = _base;
    int r = _random.nextInt(1024);
    int i = 9;
    while (a > 1 && i > 0) {
      if (r >> i > 0) {
        return a;
      }
      a ~/= 2;
      i--;
    }
    return a;
  }

  List<int> generatorRow() {
    _refreshBase();
    var board = gameManager.board;
    List<int> result = [];
    for (var i = 0; i < 5; i++) {
      var add = 0;
      if (board[0][i] == null) {
        if (_random.nextInt(10) >= 6) {
          if (_random.nextInt(2) == 1) {
            add = getNextEnemyValue();
          } else {
            add = -getNextEnegyValue();
          }
        }
      }
      result.add(add);
    }
    return result;
  }
}
