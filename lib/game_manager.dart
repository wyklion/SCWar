import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:scwar/utils/sound_manager.dart';
import 'entities/energy.dart';
import 'entities/entity.dart';
import 'entities/enemy.dart';
import 'entities/tower.dart';
import 'game.dart';
import 'game_config.dart';
import 'utils/generator.dart';
import 'utils/size_config.dart';

enum GameState {
  ready,
  playerMove,
  shooting,
  enemyMove,
  enemyCreate,
  dead,
}

class GameManager {
  SCWarGame game;
  Tower? prepareTower;
  List<List<Entity?>> board = [];
  List<Tower> towers = [];
  List<Enemy> enemies = [];
  List<Energy> energies = [];
  List<int> preMerges = [];
  int playerMoveCount = 0;
  int towerPower = 0;
  int score = 0;
  GameState _currentState = GameState.ready;
  late SizeConfig sizeConfig;
  late Generator generator;
  SoundManager soundManager = SoundManager();

  GameManager(this.game) {
    for (var i = 0; i < 10; i++) {
      var row = List<Entity?>.filled(5, null);
      board.add(row);
    }
  }

  Future<void> load() async {
    sizeConfig = SizeConfig(game.size);
    generator = Generator(this);
    await Flame.images.loadAll(['blue.png']);
    await soundManager.load();
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
    // test();
    addPrepareTower(1);
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
    // dump();
  }

  Future<void> attackEnemy(int r, int c, int attack) async {
    // log('attackEnemy $r, $c, $attack');
    var entity = board[r][c];
    if (entity is Enemy) {
      await entity.takeDamage(attack);
    } else if (entity is Energy) {
      await entity.takeDamage(attack);
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
    for (var energy in energies) {
      board[energy.r][energy.c] = null;
      if (energy.r < 9) {
        board[energy.r + 1][energy.c] = energy;
      }
      tasks.add(energy.moveOneStep());
    }
    await Future.wait(tasks);
    addRandomEnemy();
  }

  void addRandomEnemy() {
    _currentState = GameState.enemyCreate;
    var list = generator.generatorRow();
    for (var i = 0; i < 5; i++) {
      if (list[i] > 0) {
        addEnemy(0, i, list[i], 1);
      } else if (list[i] < 0) {
        addEnergy(0, i, -list[i]);
      }
    }
    mergePrepareTower();
    playerMove();
  }

  void addPreMerge(int value) {
    preMerges.add(value);
  }

  void mergePrepareTower() {
    if (preMerges.isEmpty) {
      return;
    }
    int big = 0;
    for (var m in preMerges) {
      if (m > big) {
        big = m;
      }
    }
    preMerges.clear();
    Tower tower;
    if (prepareTower is Tower) {
      tower = prepareTower!;
      if (tower.value >= big) {
        return;
      } else {
        tower.setValue(big);
      }
    } else {
      addPrepareTower(big);
    }
  }

  void dead() {
    _currentState = GameState.dead;
  }

  get prepareTowerPos => sizeConfig.getPrepareTowerPos();

  void addPrepareTower(int value) {
    var pos = prepareTowerPos;
    prepareTower = Tower(-1, -1, pos.x, pos.y, value);
    game.addContent(prepareTower);
    // log('addPrepareTower $pos $value');
  }

  void addTower(int r, int c, int value) {
    var pos = sizeConfig.getTowerPos(r, c);
    var tower = Tower(r, c, pos.x, pos.y, value);
    towers.add(tower);
    game.addContent(tower);
    // log('addTower $pos $value');
  }

  void removeTower(Tower tower) {
    if (tower == prepareTower) {
      prepareTower = null;
    } else {
      towers.remove(tower);
    }
    tower.removeFromParent();
  }

  void moveTower(Tower tower, int r, int c) {
    soundManager.playMove();
    if (tower == prepareTower) {
      prepareTower = null;
      towers.add(tower);
    }
    var tp = sizeConfig.getTowerPos(r, c);
    tower.pos.setFrom(tp);
    tower.x = tp.x;
    tower.y = tp.y;
    tower.r = r;
    tower.c = c;
    startShooting();
  }

  Future<void> swapTower(Tower tower1, Tower tower2) async {
    soundManager.playSwap();
    var tempR = tower1.r;
    var tempC = tower1.c;
    tower1.setPos(tower2.r, tower2.c);
    tower2.setPos(tempR, tempC);
    if (tower1 == prepareTower) {
      prepareTower = tower2;
      towers.remove(tower2);
      towers.add(tower1);
    }
    startShooting();
  }

  void upgradeTower(Tower tower) {
    towerPower += tower.value;
    tower.upgrade();
    startShooting();
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
    // log('addEnemy ($r,$c) $pos $value');
  }

  void removeBoardEntity(BoardEntity entity) {
    board[entity.r][entity.c] = null;
    if (entity is Enemy) {
      enemies.remove(entity);
    } else if (entity is Energy) {
      energies.remove(entity);
    }
    entity.removeFromParent();
  }

  void addEnergy(int r, int c, int value) {
    var pos = sizeConfig.getEnemyPos(r, c);
    var energy = Energy(r, c, pos.x, pos.y, value);
    energies.add(energy);
    game.addContent(energy);
    board[r][c] = energy;
    // log('addEnergy ($r,$c) $pos $value');
  }

  int getTowerTarget(int r, int c) {
    for (var i = 9; i >= 0; i--) {
      if (board[i][c] != null) {
        return i;
      }
    }
    return -1;
  }

  (Tower?, (int, int)?) checkTowerByPos(double x, double y) {
    for (var tower in towers) {
      if (tower.pos.distanceToSquared(Vector2(x, y)) <
          GameConfig.snapLenSquare) {
        return (tower, (tower.r, tower.c));
      }
    }
    return (null, sizeConfig.findNearTowerPos(x, y));
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
