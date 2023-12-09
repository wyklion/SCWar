import 'dart:developer';
import 'dart:math' as math;
import 'package:scwar/entities/entity_info.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game_data.dart';
import '../game/game_manager.dart';

class Generator {
  GameManager gameManager;
  int _count = 0;
  int enemyCount = 0;
  int afterBigEnemyCount = 0;
  int afterEnergyCount = 0;
  late List<List<EntityInfo>> queue;
  late math.Random _random;
  late GameData _data;
  Generator(this.gameManager) {
    _random = gameManager.random;
    _data = gameManager.data;
    queue = [];
    for (var i = 0; i < GameConfig.row; i++) {
      queue.add([]);
      for (var j = 0; j < GameConfig.col; j++) {
        queue[i].add(EntityInfo(0, 0, EntityType.empty));
      }
    }
  }

  void init() {
    _count = 0;
    enemyCount = 0;
    afterBigEnemyCount = 0;
    afterEnergyCount = 10;
    for (var i = 0; i < GameConfig.row; i++) {
      for (var j = 0; j < GameConfig.col; j++) {
        queue[i][j].setEmpty();
      }
    }
  }

  /// 生成怪基础分：炮塔总分除以5取整。
  /// 小怪值：基础分的1倍到3倍之间
  /// 大怪值：取最大炮塔0.3倍和基础分1.7倍的平均值为基础，生成基础的2到3倍之间。
  ///   极限情况，最平均时全是1炮，大怪基础是(0.3+1.7)=2，算出大怪是4-6之间。
  ///   只有一个5分炮，大怪基础(5*0.3+1.7)=3.2，大怪在6.4-9.6之间。
  /// 根据炮分等级加成*(1+0.002*baseLevel)
  double getNextEnemyValue({int? size = 1}) {
    _count++;
    double base = (_data.towerPower + 1) / 5;
    if (base < 1) {
      base = 1;
    }
    double result;
    if (size == 1) {
      result = base + _random.nextDouble() * (base * 2);
      enemyCount++;
      if (enemyCount % 5 == 0) {
        // result *= 2;
      }
      afterBigEnemyCount++;
    } else {
      afterBigEnemyCount = 0;
      double bigBase = base * 1.7 + _data.bigTower * 0.3;
      result = bigBase * 2 + _random.nextDouble() * bigBase;
    }
    afterEnergyCount++;
    // 炮分等级加成
    result *= (1 + 0.001 * _data.baseLevel);
    if (result < 99999999) {
      result = result.floorToDouble();
    }
    // log('power:${_data.towerPower}, base:$base, baseLevel:$_data.baseLevel result: $result');
    return result;
  }

  /// 资源值生成：60%基础分的1倍，30%基础分2倍，10%基础分4倍。
  double getNextEnegyValue() {
    _count++;
    double result = _data.base;
    int r = _random.nextInt(10);
    if (r >= 6 && r <= 8) {
      result = _data.base * 2;
    } else if (r >= 9) {
      result = _data.base * 4;
    }
    return result;
  }

  // 一行最多几个大怪，炮塔分4分以下没有，100分以下1个，以上2个。
  int getMaxBlock4Count() {
    if (_data.towerPower < 4) {
      return 0;
    } else if (_data.towerPower < 100) {
      return 1;
    } else {
      return 2;
    }
  }

  // 一行怪最多占几格：炮分4以下2格，64以下3格，128以下4格，以上5格。
  int getMaxCount() {
    if (_data.towerPower < 4) {
      return 2;
    } else if (_data.towerPower < 64) {
      return 3;
    } else if (_data.towerPower < 512) {
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

  void makeBigEnemy() {
    var b4 = getEmpty4Block();
    var max4 = getMaxBlock4Count();
    var count4 = 0;
    for (var i = 0; i < b4.length; i++) {
      if (count4 >= max4) {
        break;
      }
      if (b4[i] == 1) {
        if (_random.nextInt(4) == 1) {
          queue[1][i].setEnemy(getNextEnemyValue(size: 2), 2);
          queue[1][i + 1].setEnemy(0, 2);
          queue[0][i].setEnemy(0, 2);
          queue[0][i + 1].setEnemy(0, 2);
          count4++;
          // 下一列没法生成大怪
          i++;
        }
      }
    }
  }

  void makeSmallEntity() {
    var left = getMaxCount();
    var row = [0, 1, 2, 3, 4];
    for (var i = 0; i < GameConfig.col; i++) {
      if (queue[0][i].type == EntityType.enemy) {
        row.remove(i);
        left--;
      }
    }
    var tryCount = row.length;
    for (var i = 0; i < tryCount; i++) {
      if (left <= 0) {
        break;
      }
      var idx = _random.nextInt(row.length);
      var col = row[idx];
      row.removeAt(idx);
      if ((i == 0 && tryCount >= 3) || _random.nextInt(2) == 1) {
        // if (afterEnergyCount >= 2 &&
        //     (afterEnergyCount >= 10 || _random.nextInt(3) == 1)) {
        if (afterEnergyCount >= 6 || _random.nextInt(3) == 1) {
          afterEnergyCount = 0;
          if (_random.nextInt(3) == 1) {
            queue[0][col].setEnergy(2, EntityType.energyMultiply);
          } else {
            queue[0][col].setEnergy(getNextEnegyValue(), EntityType.energy);
          }
        } else {
          queue[0][col].setEnemy(getNextEnemyValue(), 1);
        }
        left--;
      }
    }
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

  /// 第一行生成一个资源，一个怪。
  void makeFirstRow() {
    var row = [0, 1, 2, 3, 4];
    var (makeRow, leftRow) = getRandomCols(row, 1, 10);
    row = leftRow;
    for (var i = 0; i < makeRow.length; i++) {
      queue[0][makeRow[i]].setEnergy(getNextEnegyValue(), EntityType.energy);
    }
    afterEnergyCount = 0;
    var (makeEnemy, _) = getRandomCols(row, 1, 7);
    for (var i = 0; i < makeEnemy.length; i++) {
      queue[0][makeEnemy[i]].setEnemy(getNextEnemyValue(), 1);
    }
  }

  /// 第二行         0 1 2 3 4
  ///                  下移
  /// 第一行         0 1 2 3 4
  ///                  下移
  /// 发送出现在屏幕上 0 1 2 3 4
  ///
  /// 有两行预生成行。每次生成时，先在第一行生成小怪。
  ///   在一行上限怪数内补充生成小怪/资源。
  ///   如果可以生成且剩三个格及以上，至少生成一个，之后50%机率生成东西
  ///     其中1/3机率生成炮资源（连续6个怪后必出资源）
  ///       资源中1/3出随机2倍，2/3出普通资源
  ///     2/3机率生成怪。
  /// 返回第一行数据给外部。
  /// 然后在第二行可生成位置（会被第一行大怪档住）生成大怪。
  ///   在大怪数上限内，1/4机率生成大怪。
  List<EntityInfo> getNextRow() {
    if (_count == 0) {
      makeFirstRow();
    } else {
      makeSmallEntity();
    }
    List<EntityInfo> row = [];
    for (var i = 0; i < GameConfig.col; i++) {
      var e = queue[0][i];
      row.add(e.clone());
      e.copyFrom(queue[1][i]);
      queue[1][i].setEmpty();
    }
    makeBigEnemy();
    // log('towerPower:${_data.towerPower} base:${_data.base.toString()}');
    // log('queue[1]: ${queue[1].toString()}');
    // log('queue[0]: ${queue[0].toString()}');
    // log('new row: ${row.toString()}');
    return row;
  }
}
