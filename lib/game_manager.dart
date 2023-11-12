import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'entity.dart';
import 'game.dart';
import 'game_config.dart';

enum GameState {
  ready,
  playerMove,
  shooting,
  enemyMove,
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
}

class GameManager {
  SCWarGame game;
  late SizeConfig sizeConfig;
  int playerMoveCount = 0;
  late Tower prepareTower;
  List<Tower> towers = [];
  List<Enemy> enemies = [];
  GameState _currentState = GameState.ready;

  GameManager(this.game) {
    towers = [];
    enemies = [];
  }

  void setSize(Vector2 size) {
    sizeConfig = SizeConfig(size);
  }

  Vector2 get size => sizeConfig.size;

  GameState get currentState => _currentState;

  void startGame() {
    playerMoveCount = 0;
    addPrepareTower(4);
    addTower(0, 0, 1);
    addTower(0, 1, 4);
    addTower(0, 4, 1024);
    addTower(1, 3, 2048);
    addRandomEnemy();
    _currentState = GameState.playerMove;
  }

  void addRandomEnemy() {
    addEnemy(0, 0, 128, 1);
    addEnemy(1, 1, 1024, 1);
    addEnemy(2, 2, 8192, 1);
    addEnemy(4, 3, 8192, 1);
    addEnemy(6, 4, 16384, 1);
    addEnemy(7, 4, 32768, 1);
    addEnemy(8, 2, 65536, 1);
    addEnemy(9, 3, 131072, 1);
  }

  void playerMove() {
    _currentState = GameState.playerMove;
  }

  void startShooting() {
    _currentState = GameState.shooting;
  }

  void enemyMove() {
    _currentState = GameState.enemyMove;
  }

  void dead() {
    _currentState = GameState.dead;
  }

  void addPrepareTower(int value) {
    var pos = sizeConfig.getPrepareTowerPos();
    prepareTower = Tower(pos.x, pos.y, value);
    game.addContent(prepareTower);
    log('addPrepareTower $pos $value');
  }

  void addTower(int r, int c, int value) {
    var pos = sizeConfig.getTowerPos(r, c);
    var tower = Tower(pos.x, pos.y, value);
    towers.add(tower);
    game.addContent(tower);
    log('addTower $pos $value');
  }

  void addEnemy(int r, int c, int value, int body) {
    var pos = sizeConfig.getEnemyPos(r, c);
    var enemy = Enemy(pos.x, pos.y, value, 1);
    enemies.add(enemy);
    game.addContent(enemy);
    log('addEnemy ($r,$c) $pos $value');
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
}
