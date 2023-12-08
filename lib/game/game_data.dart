/// 资源基础分：炮总分80（5炮平均分16）以上开始基础分升到2，5炮平均32，基础分到4。生成资源按概率生成1-3倍。
/// 炮塔分等级：总分从80开始是1级，每多一倍加1级。怪分成生有加成。
class GameData {
  int playerMoveCount = 0;
  double score = 0;
  int enemyCount = 0;
  int energyCount = 0;
  int energyMultiplyCount = 0;
  int mergeCount = 0;
  int moveCount = 0;
  int swapCount = 0;
  // 下面是过程中算的
  double towerPower = 0;
  double bigTower = 0;
  double base = 1;
  int baseLevel = 0;

  void clear() {
    playerMoveCount = 0;
    score = 0;
    enemyCount = 0;
    energyCount = 0;
    energyMultiplyCount = 0;
    mergeCount = 0;
    moveCount = 0;
    swapCount = 0;
    towerPower = 0;
    bigTower = 0;
    base = 1;
    baseLevel = 0;
  }

  void addTower(double value) {
    towerPower += value;
    if (value > bigTower) {
      bigTower = value;
    }
  }

  void upgradeTower(double value, {bool merge = false}) {
    if (!merge) {
      towerPower += value;
    }
    if (value * 2 > bigTower) {
      bigTower = value * 2;
    }
  }

  void computeInit() {
    _refreshBase();
  }

  void computeMove() {
    playerMoveCount++;
    _refreshBase();
  }

  void _refreshBase() {
    double power = towerPower / 80;
    while (base <= power) {
      base *= 2;
      baseLevel++;
    }
  }

  void saveJson(dynamic json) {
    json['score'] = score;
    json['playerMoveCount'] = playerMoveCount;
    json['enemyCount'] = enemyCount;
    json['energyCount'] = energyCount;
    json['energyMultiplyCount'] = energyMultiplyCount;
    json['mergeCount'] = mergeCount;
    json['moveCount'] = moveCount;
    json['swapCount'] = swapCount;
  }

  void loadJson(dynamic json) {
    score = json['score'] ?? 0;
    playerMoveCount = json['playerMoveCount'] ?? 0;
    enemyCount = json['enemyCount'] ?? 0;
    energyCount = json['energyCount'] ?? 0;
    energyMultiplyCount = json['energyMultiplyCount'] ?? 0;
    mergeCount = json['mergeCount'] ?? 0;
    moveCount = json['moveCount'] ?? 0;
    swapCount = json['swapCount'] ?? 0;
  }
}
