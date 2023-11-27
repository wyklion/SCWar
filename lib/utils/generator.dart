import 'dart:developer';
import 'dart:math' as math;

import 'package:scwar/game_config.dart';

import '../game_manager.dart';

typedef EnemyInfo = (int value, int size);

class Generator {
  GameManager gameManager;
  int _base = 1;
  int enemyCount = 0;
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

  /// 基础分，比炮总分/20大一点的最小的2的幂
  void _refreshBase() {
    double power = gameManager.towerPower / 20;
    while (_base < power) {
      _base *= 2;
    }
  }

  /// 生成怪值：基础分的3倍到6倍之间，如果是大怪，6倍-12倍之间。
  int getNextEnemyValue({int? size = 1}) {
    // int r = _random.nextInt(3);
    var b = size == 1 ? _base : _base * 2;
    b *= 3;
    enemyCount++;
    if (enemyCount % 3 == 0) {
      b *= 3;
    }
    int result = b + _random.nextInt(b);
    // int result = _base * math.pow(2, r).toInt();
    return result;
  }

  /// 资源值生成：基础分的1倍或2倍。
  int getNextEnegyValue() {
    int r = _random.nextInt(2);
    int result = _base * (1 + r);
    return result;
    // int a = _base;
    // int r = _random.nextInt(1024);
    // int i = 9;
    // while (a > 1 && i > 0) {
    //   if (r >> i > 0) {
    //     return a;
    //   }
    //   a ~/= 2;
    //   i--;
    // }
    // return a;
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

  // 一行最多几个大怪，炮塔分4分以下没有，100分以下1个，以上2个。
  int getMaxBlock4Count() {
    if (gameManager.towerPower < 4) {
      return 0;
    } else if (gameManager.towerPower < 100) {
      return 1;
    } else {
      return 2;
    }
  }

  // 一行怪最多占几格：炮分4以下2格，64以下3格，128以下4格，以上5格。
  int getMaxCount() {
    if (gameManager.towerPower < 4) {
      return 2;
    } else if (gameManager.towerPower < 64) {
      return 3;
    } else if (gameManager.towerPower < 128) {
      return 4;
    } else {
      return 5;
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

  /// 先生成大怪，在大怪数上限内，50%机率生成大怪。
  /// 还需生成的次数是：一行怪最多占几格减去大怪数*2
  ///   如果可以生成，至少生成一个
  ///   之后50%机率生成，其中1/3机率生成炮资源，2/3机率生成怪。
  void generateNextRow({int energy = 0}) {
    var b4 = getEmpty4Block();
    var max4 = getMaxBlock4Count();
    var count4 = 0;
    var row = [0, 1, 2, 3, 4];
    for (var i = 0; i < b4.length; i++) {
      if (count4 >= max4) {
        break;
      }
      if (b4[i] == 1) {
        var make4 = _random.nextBool();
        if (make4) {
          row.remove(i);
          row.remove(i + 1);
          if (i < b4.length - 1) {
            b4[i + 1] = 0;
          }
          queue[1][i] = (getNextEnemyValue(), 2);
          queue[1][i + 1] = (0, 2);
          count4++;
        }
      }
    }
    var count = getMaxCount();
    count -= count4 * 2;
    if (energy > 0) {
      var (makeRow, leftRow) = getRandomCols(row, 1, 10);
      row = leftRow;
      for (var i = 0; i < makeRow.length; i++) {
        queue[1][makeRow[i]] = (-getNextEnegyValue(), 1);
      }
      count -= energy;
      if (count > 0) {
        var (makeEnemy, _) = getRandomCols(row, count, 7);
        for (var i = 0; i < makeEnemy.length; i++) {
          queue[1][makeEnemy[i]] = (getNextEnemyValue(), 1);
        }
      }
    } else {
      var tryCount = row.length;
      for (var i = 0; i < tryCount; i++) {
        if (count <= 0) {
          break;
        }
        var idx = _random.nextInt(row.length);
        var col = row[idx];
        row.removeAt(idx);
        if (i == 0 || _random.nextInt(2) == 1) {
          if (_random.nextInt(3) == 1) {
            queue[1][col] = (-getNextEnegyValue(), 1);
          } else {
            queue[1][col] = (getNextEnemyValue(), 1);
          }
          count--;
        }
      }
    }
    // log('towerPower:${gameManager.towerPower} base:${_base.toString()}');
    // log('queue[1]: ${queue[1].toString()}');
  }

  (List<int>, List<int>) getRandomCols(List<int> row, int count, int rate) {
    List<int> result = [];
    for (var i = 0; i < count; i++) {
      if (_random.nextInt(10) < rate) {
        var idx = _random.nextInt(row.length);
        var col = row[idx];
        row.removeAt(idx);
        result.add(col);
      }
    }
    return (result, row);
  }

  /// 初始行必有一个资源。
  void initRow() {
    // int x = 1 + _random.nextInt(2);
    // var row = [0, 1, 2, 3, 4];
    // while (x > 0) {
    //   x--;
    //   var idx = _random.nextInt(row.length);
    //   var c = row[idx];
    //   row.removeAt(idx);
    //   var value = 1 + _random.nextInt(4);
    //   queue[0][c] = (value, 1);
    // }
    generateNextRow(energy: 1);
    getNextRow();
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
