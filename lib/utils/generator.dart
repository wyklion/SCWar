import 'dart:developer';
import 'dart:math' as math;
import 'package:scwar/entities/energy.dart';
import 'package:scwar/game_config.dart';
import '../game_manager.dart';

class EntityInfo {
  int value;
  int size;
  EntityType type;
  EntityInfo(this.value, this.size, this.type);

  EntityInfo clone() {
    return EntityInfo(value, size, type);
  }

  setEnemy(int value, int size) {
    type = EntityType.enemy;
    this.value = value;
    this.size = size;
  }

  setEnergy(int value, EntityType type) {
    this.type = type;
    this.value = value;
    size = 1;
  }

  setEmpty() {
    value = 0;
    size = 0;
    type = EntityType.empty;
  }

  copyFrom(EntityInfo info) {
    value = info.value;
    size = info.size;
    type = info.type;
  }

  @override
  String toString() {
    if (type == EntityType.empty) {
      return 'empty';
    } else if (type == EntityType.enemy) {
      return 'em[$value($size)]';
    } else if (type == EntityType.energy) {
      return 'en[$value]';
    } else {
      return 'en2[$value]';
    }
  }
}

class Generator {
  GameManager gameManager;
  int _base = 1;
  int enemyCount = 0;
  int afterEnergyCount = 0;
  late List<List<EntityInfo>> queue;
  late math.Random _random;
  Generator(this.gameManager) {
    _random = gameManager.random;
    queue = [];
    for (var i = 0; i < GameConfig.row; i++) {
      queue.add([]);
      for (var j = 0; j < GameConfig.col; j++) {
        queue[i].add(EntityInfo(0, 0, EntityType.empty));
      }
    }
  }

  void init() {
    _base = 1;
    for (var i = 0; i < GameConfig.row; i++) {
      for (var j = 0; j < GameConfig.col; j++) {
        queue[i][j].setEmpty();
      }
    }
    initRow();
  }

  /// 基础分，10炮平均分在32开始基础分升到2，平均64，基础分到4。生成资源按概率生成1-3倍。
  void _refreshBase() {
    double power = gameManager.towerPower / 320;
    while (_base <= power) {
      _base *= 2;
    }
  }

  /// 生成怪基础分：炮塔总分除以5取整。
  /// 生成怪值：基础分的1倍到3倍之间，如果是大怪，4倍-8倍之间。
  /// 每5个怪出一个双倍分的怪。
  int getNextEnemyValue({int? size = 1}) {
    // int r = _random.nextInt(3);
    int base = ((gameManager.towerPower + 1) / 5).ceil();
    var b = size == 1 ? base : base * 4;
    // b *= 2;
    enemyCount++;
    afterEnergyCount++;
    if (enemyCount % 5 == 0) {
      b *= 2;
    }
    int result = b + _random.nextInt(b * 2);
    // log('power:${gameManager.towerPower}, base:$base, b:$b, result: $result');
    // int result = _base * math.pow(2, r).toInt();
    return result;
  }

  /// 资源值生成：基础分的1倍或2倍。
  int getNextEnegyValue() {
    afterEnergyCount = 0;
    int result = _base;
    int r = _random.nextInt(10);
    if (r >= 5 && r <= 7) {
      result = _base * 2;
    } else if (r >= 9) {
      result = _base * 4;
    }
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
      if (queue[0][i].type != EntityType.empty) {
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
  ///   如果可以生成且剩三个格及以上，至少生成一个
  ///   之后50%机率生成东西
  ///     其中1/3机率生成炮资源（连续生成3个怪及以内不会生成资源。连续10个怪后必出资源）
  ///       资源中1/3出随机2倍，2/3出普通资源
  ///     2/3机率生成怪。
  /// 指定生成多少个资源的，剩下的60%都是怪。
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
          queue[1][i].setEnemy(getNextEnemyValue(), 2);
          queue[1][i + 1].setEnemy(0, 2);
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
        queue[1][makeRow[i]].setEnergy(getNextEnegyValue(), EntityType.energy);
      }
      count -= energy;
      if (count > 0) {
        var (makeEnemy, _) = getRandomCols(row, count, 7);
        for (var i = 0; i < makeEnemy.length; i++) {
          queue[1][makeEnemy[i]].setEnemy(getNextEnemyValue(), 1);
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
        if ((i == 0 && tryCount >= 3) || _random.nextInt(2) == 1) {
          if (afterEnergyCount >= 3 &&
              (afterEnergyCount >= 10 || _random.nextInt(3) == 1)) {
            if (_random.nextInt(3) == 1) {
              queue[1][col].setEnergy(2, EntityType.energyMultiply);
            } else {
              queue[1][col].setEnergy(getNextEnegyValue(), EntityType.energy);
            }
          } else {
            queue[1][col].setEnemy(getNextEnemyValue(), 1);
          }
          count--;
        }
      }
    }
    log('towerPower:${gameManager.towerPower} base:${_base.toString()}');
    log('queue[1]: ${queue[1].toString()}');
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

  List<EntityInfo> getNextRow() {
    _refreshBase();
    List<EntityInfo> row = [];
    for (var i = 0; i < GameConfig.col; i++) {
      row.add(queue[0][i].clone());
      queue[0][i].copyFrom(queue[1][i]);
      queue[1][i].setEmpty();
    }
    generateNextRow();
    // log('queue[1]: ${queue[1].toString()}');
    // log('queue[0]: ${queue[0].toString()}');
    // log('new row: ${row.toString()}');
    return row;
  }
}
