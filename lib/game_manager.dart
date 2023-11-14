import 'dart:developer';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'entities/enemy.dart';
import 'entities/tower.dart';
import 'game.dart';
import 'game_config.dart';

enum GameState {
  ready,
  playerMove,
  shooting,
  enemyMove,
  enemyCreate,
  dead,
}

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
}

class GameManager {
  SCWarGame game;
  late SizeConfig sizeConfig;
  int playerMoveCount = 0;
  late Tower prepareTower;
  List<List<Enemy?>> board = [];
  List<Tower> towers = [];
  List<Enemy> enemies = [];
  GameState _currentState = GameState.ready;
  math.Random _random = math.Random();

  GameManager(this.game) {
    for (var i = 0; i < 10; i++) {
      var row = List<Enemy?>.filled(5, null);
      board.add(row);
    }
  }

  void setSize(Vector2 size) {
    sizeConfig = SizeConfig(size);
  }

  Vector2 get size => sizeConfig.size;

  GameState get currentState => _currentState;

  void test() {
    addTower(0, 0, 2);
    addTower(0, 1, 4);
    addTower(0, 2, 128);
    addTower(0, 4, 1024);
    addTower(1, 3, 2048);
    addEnemy(0, 0, 4, 1);
    addEnemy(8, 1, 7, 1);
    addEnemy(1, 3, 1024, 1);
    addEnemy(2, 2, 8, 1);
    addEnemy(4, 3, 3252, 1);
    addEnemy(6, 4, 253, 1);
    addEnemy(7, 4, 253, 1);
    addEnemy(8, 2, 524, 1);
    addEnemy(9, 3, 235, 1);
  }

  void startGame() {
    playerMoveCount = 0;
    test();
    addPrepareTower(4);
    addRandomEnemy();
    _currentState = GameState.playerMove;
  }

  void playerMove() {
    log('state playerMove...');
    _currentState = GameState.playerMove;
  }

  void startShooting() async {
    if (_currentState != GameState.playerMove) {
      return;
    }
    playerMoveCount++;
    log('state shooting...');
    _currentState = GameState.shooting;
    List<Future<void>> tasks = [];
    for (var tower in towers) {
      var enemyRow = getTowerTarget(tower.r, tower.c);
      var dis = sizeConfig.getTowerEnemyDistance(tower.r, enemyRow);
      tasks.add(tower.shoot(enemyRow, dis));
    }
    await Future.wait(tasks);
    await enemyMove();
    dump();
  }

  Future<void> attackEnemy(int r, int c, int attack) async {
    log('attackEnemy $r, $c, $attack');
    Enemy? enemy = board[r][c];
    if (enemy != null) {
      await enemy.takeDamage(attack);
    }
  }

  Future<void> enemyMove() async {
    log('state evemyMove...');
    _currentState = GameState.enemyMove;
    List<Future<void>> tasks = [];
    for (var enemy in enemies) {
      board[enemy.r][enemy.c] = null;
      if (enemy.r < 9) {
        board[enemy.r + 1][enemy.c] = enemy;
      }
      tasks.add(enemy.moveOneStep());
    }
    await Future.wait(tasks);
    addRandomEnemy();
  }

  void addRandomEnemy() {
    _currentState = GameState.enemyCreate;
    for (var i = 0; i < 5; i++) {
      if (board[0][i] == null) {
        if (_random.nextInt(10) >= 6) {
          addEnemy(0, i, _random.nextInt(1000), 1);
        }
      }
    }
    playerMove();
  }

  void dead() {
    _currentState = GameState.dead;
  }

  void addPrepareTower(int value) {
    var pos = sizeConfig.getPrepareTowerPos();
    prepareTower = Tower(-1, -1, pos.x, pos.y, value);
    game.addContent(prepareTower);
    log('addPrepareTower $pos $value');
  }

  void addTower(int r, int c, int value) {
    var pos = sizeConfig.getTowerPos(r, c);
    var tower = Tower(r, c, pos.x, pos.y, value);
    towers.add(tower);
    game.addContent(tower);
    log('addTower $pos $value');
  }

  void addEnemy(int r, int c, int value, int body) {
    if (board[r][c] != null) {
      return;
    }
    var pos = sizeConfig.getEnemyPos(r, c);
    var enemy = Enemy(r, c, pos.x, pos.y, value, 1);
    enemies.add(enemy);
    game.addContent(enemy);
    board[r][c] = enemy;
    log('addEnemy ($r,$c) $pos $value');
  }

  void removeEnemy(Enemy enemy) {
    board[enemy.r][enemy.c] = null;
    enemies.remove(enemy);
    enemy.removeFromParent();
  }

  int getTowerTarget(int r, int c) {
    for (var i = 9; i >= 0; i--) {
      if (board[i][c] is Enemy) {
        return i;
      }
    }
    return -1;
  }

  Tower? checkTowerByPos(double x, double y) {
    for (var tower in towers) {
      if (tower.pos.distanceToSquared(Vector2(x, y)) <
          GameConfig.snapLenSquare) {
        return tower;
      }
    }
    return null;
  }

  void handlePlayerMove() {
    playerMoveCount++;
    // 更新炮塔和敌人的位置、数值等
  }

  void dump() {
    var s = '';
    for (var i = 0; i < 10; i++) {
      for (var j = 0; j < 5; j++) {
        s += board[i][j] != null ? '*' : '_';
      }
      s += '\n';
    }
    log(s);
  }
}
