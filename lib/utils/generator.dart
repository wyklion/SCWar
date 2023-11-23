import 'dart:developer';
import 'dart:math' as math;

import 'package:scwar/game_config.dart';

import '../game_manager.dart';

typedef EnemyInfo = (int value, int size);

class Generator {
  GameManager gameManager;
  int _base = 1;
  late List<List<EnemyInfo>> queue;
  final math.Random _random = math.Random();
  Generator(this.gameManager) {
    queue = [];
    for (var i = 0; i < GameConfig.row; i++) {
      queue.add([]);
      for (var j = 0; j < GameConfig.col; j++) {
        queue[i].add((0, 0));
      }
    }
  }

  void init() {
    _base = 1;
    for (var i = 0; i < GameConfig.row; i++) {
      for (var j = 0; j < GameConfig.col; j++) {
        queue[i][j] = (0, 0);
      }
    }
    initRow();
  }

  void _refreshBase() {
    double power = gameManager.towerPower / 2;
    while (_base < power) {
      _base *= 2;
    }
  }

  int getNextEnemyValue({int? size = 1}) {
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

  // List<int> generatorRow() {
  //   _refreshBase();
  //   var board = gameManager.board;
  //   List<int> result = [];
  //   for (var i = 0; i < 5; i++) {
  //     var add = 0;
  //     if (board[0][i] == null) {
  //       if (_random.nextInt(10) >= 6) {
  //         if (_random.nextInt(2) == 1) {
  //           add = getNextEnemyValue();
  //         } else {
  //           add = -getNextEnegyValue();
  //         }
  //       }
  //     }
  //     result.add(add);
  //   }
  //   return result;
  // }

  void initRow() {
    int x = 1 + _random.nextInt(2);
    var row = [0, 1, 2, 3, 4];
    while (x > 0) {
      x--;
      var idx = _random.nextInt(row.length);
      var c = row[idx];
      row.removeAt(idx);
      var value = 1 + _random.nextInt(4);
      queue[0][c] = (value, 1);
    }
    generateNextRow();
  }

  int getMaxBlock4Count() {
    if (gameManager.towerPower < 4) {
      return 0;
    } else if (gameManager.towerPower < 100) {
      return 1;
    } else {
      return 2;
    }
  }

  List<int> getEmpty4Block() {
    var result = [1, 1, 1, 1];
    for (var i = 0; i < GameConfig.col; i++) {
      if (queue[0][i].$2 != 0) {
        if (i == 0) {
          result[i] = 0;
        } else if (i == GameConfig.col - 1) {
          result[i - 1] = 0;
        } else {
          result[i] = result[i - 1] = 0;
        }
      }
    }
    return result;
  }

  void generateNextRow() {
    var b4 = getEmpty4Block();
    var max4 = getMaxBlock4Count();
    var count4 = 0;
    for (var i = 0; i < b4.length; i++) {
      if (count4 >= max4) {
        break;
      }
      if (b4[i] == 1) {
        var make4 = _random.nextBool();
        if (make4) {
          if (i < b4.length - 1) {
            b4[i + 1] = 0;
          }
          queue[1][i] = (getNextEnemyValue(), 2);
          queue[1][i + 1] = (0, 2);
          count4++;
        }
      }
    }
    for (var i = 0; i < GameConfig.col; i++) {
      if (queue[1][i].$2 == 0) {
        if (_random.nextInt(2) == 1) {
          if (_random.nextInt(3) == 1) {
            queue[1][i] = (getNextEnegyValue(), 1);
          } else {
            queue[1][i] = (-getNextEnemyValue(), 1);
          }
        }
      }
    }
  }

  List<EnemyInfo> getNextRow() {
    _refreshBase();
    List<EnemyInfo> row = [];
    for (var i = 0; i < GameConfig.col; i++) {
      row.add(queue[0][i]);
      queue[0][i] = queue[1][i];
      queue[1][i] = (0, 0);
    }
    generateNextRow();
    // log('queue[1]: ${queue[1].toString()}');
    // log('queue[0]: ${queue[0].toString()}');
    // log('new row: ${row.toString()}');
    return row;
  }
}
