import 'dart:async';
import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
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
  List<List<BoardEntity?>> board = [];
  List<Tower> towers = [];
  List<Enemy> enemies = [];
  List<Energy> energies = [];
  List<int> preMerges = [];
  int playerMoveCount = 0;
  int towerPower = 0;
  int score = 0;
  GameState _currentState = GameState.ready;
  int _attackCount = 0;
  Completer? _attackCompleter;
  late SizeConfig sizeConfig;
  late Generator generator;
  SoundManager soundManager = SoundManager();

  GameManager(this.game) {
    for (var i = 0; i < GameConfig.row; i++) {
      var row = List<BoardEntity?>.filled(GameConfig.col, null);
      board.add(row);
    }
    generator = Generator(this);
  }

  Future<void> load() async {
    sizeConfig = SizeConfig(game.size);
    await Flame.images.loadAll(['blue.png']);
    await soundManager.load();
  }

  Vector2 get size => sizeConfig.size;

  GameState get currentState => _currentState;

  void test() {
    // addTower(0, 0, 2);
    // addTower(0, 1, 4);
    // addTower(0, 2, 128);
    // addTower(0, 4, 1024);
    // addTower(1, 3, 2048);
    // addEnemy(1, 1, 8, 1);
    // addEnergy(2, 1, 2);
    // addEnemy(8, 1, 7, 1);
    // addEnemy(1, 3, 1024, 1);
    // addEnemy(2, 2, 8, 1);
    // addEnemy(4, 3, 3252, 1);
    // addEnemy(6, 4, 253, 1);
    // addEnemy(7, 4, 253, 1);
    // addEnemy(8, 2, 524, 1);
    // addEnemy(9, 3, 235, 1);
  }

  void setState(GameState status) {
    var oldState = _currentState;
    _currentState = status;
    switch (status) {
      case GameState.ready:
        break;
      case GameState.playerMove:
        log('state playerMove...');
        playerMove();
      case GameState.shooting:
        if (oldState == GameState.playerMove) {
          log('state shooting...');
          startShooting();
        }
      case GameState.enemyMove:
        log('state evemyMove...');
        enemyMove();
      case GameState.enemyCreate:
        break;
      case GameState.dead:
        dead();
        break;
    }
  }

  void clear() {
    for (var i = 0; i < enemies.length; i++) {
      enemies[i].removeFromParent();
    }
    enemies = [];
    for (var i = 0; i < energies.length; i++) {
      energies[i].removeFromParent();
    }
    energies = [];
    for (var i = 0; i < towers.length; i++) {
      towers[i].removeFromParent();
    }
    towers = [];
    if (prepareTower != null) {
      prepareTower!.removeFromParent();
    }
    for (var i = 0; i < GameConfig.row; i++) {
      for (var j = 0; j < GameConfig.col; j++) {
        board[i][j] = null;
      }
    }
    preMerges.clear();
    playerMoveCount = 0;
    towerPower = 0;
    score = 0;
    game.menu.updateScore();
    _currentState = GameState.ready;
  }

  void restartGame() {
    clear();
    startGame();
  }

  void startGame() {
    generator.init();
    playerMoveCount = 0;
    test();
    addPrepareTower(1);
    addRandomEnemy();
    setState(GameState.playerMove);
  }

  void playerMove() {}

  void startShooting() async {
    playerMoveCount++;
    _currentState = GameState.shooting;
    List<Future<void>> tasks = [];
    var hasTarget = false;
    for (var tower in towers) {
      if (!hasTarget) {
        List<BoardEntity> entityCol = getColEnemys(tower.c);
        if (entityCol.isNotEmpty) {
          hasTarget = true;
        }
      }
      tasks.add(tower.shoot());
    }
    if (hasTarget) {
      _attackCount = 0;
      _attackCompleter = Completer();
    }
    await Future.wait(tasks);
    if (hasTarget) {
      await _attackCompleter!.future;
    }
    mergePrepareTower();
    setState(GameState.enemyMove);
  }

  Future<void> attackEnemy(int r, int c, int attack) async {
    // log('attackEnemy $r, $c, $attack');
    _attackCount++;
    var entity = board[r][c];
    if (entity is Enemy) {
      await entity.takeDamage(attack);
    } else if (entity is Energy) {
      await entity.takeDamage(attack);
    }
    // log('attackEnemy $r, $c, $attack end.');
    _attackCount--;
    if (_attackCount == 0 && !_attackCompleter!.isCompleted) {
      _attackCompleter!.complete();
      // log('attackEnemy complete');
    }
  }

  Future<void> enemyMove() async {
    _currentState = GameState.enemyMove;
    for (var i = 0; i < GameConfig.col; i++) {
      if (board[GameConfig.row - 1][i] is Enemy) {
        setState(GameState.dead);
        return;
      }
    }
    List<Future<bool>> tasks = [];
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
    var row = generator.getNextRow();
    for (var i = 0; i < GameConfig.col; i++) {
      if (row[i].$1 > 0) {
        addEnemy(0, i, row[i].$1, row[i].$2);
      } else if (row[i].$1 < 0) {
        addEnergy(0, i, -row[i].$1);
      }
    }
    // var list = generator.generatorRow();
    // for (var i = 0; i < GameConfig.col; i++) {
    //   if (list[i] > 0) {
    //     addEnemy(0, i, list[i], 1);
    //   } else if (list[i] < 0) {
    //     addEnergy(0, i, -list[i]);
    //   }
    // }
    setState(GameState.playerMove);
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

  // void towerAction(Tower tower, Tower? mergingTower, Tower? swapTower, Vector2? movePos){
  //   if (mergingTower != null) {
  //     upgradeTower(mergingTower!);
  //     removeTower(this);
  //   } else if (swapTower != null) {
  //     // 还原颜色
  //     paint.color = Colors.blue;
  //     swapTower(this, swapTower!);
  //   } else if (movePos != null) {
  //     moveTower(this, movePos!.$1, movePos!.$2);
  //   } else {
  //     goBack();
  //   }
  // }

  void moveTower(Tower tower, int r, int c) {
    soundManager.playMove();
    if (tower == prepareTower) {
      prepareTower = null;
      towers.add(tower);
      towerPower += tower.value;
    }
    var tp = sizeConfig.getTowerPos(r, c);
    tower.pos.setFrom(tp);
    tower.x = tp.x;
    tower.y = tp.y;
    tower.r = r;
    tower.c = c;
    setState(GameState.shooting);
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
    setState(GameState.shooting);
  }

  void upgradeTower(Tower tower, bool fromPrepare) {
    if (fromPrepare) {
      towerPower += tower.value;
    }
    tower.upgrade();
    setState(GameState.shooting);
  }

  void addEnemy(int r, int c, int value, int body) {
    if (board[r][c] != null) {
      return;
    }
    var pos = sizeConfig.getEnemyPos(r, c, body);
    var enemy = Enemy(r, c, pos.x, pos.y, value, body);
    enemies.add(enemy);
    game.addContent(enemy);
    board[r][c] = enemy;
    // log('addEnemy ($r,$c) $pos $value');
  }

  void removeBoardEntity(BoardEntity entity) {
    board[entity.r][entity.c] = null;
    if (entity is Enemy) {
      enemies.remove(entity);
      // 杀怪加分
      score += entity.score;
      game.menu.updateScore();
    } else if (entity is Energy) {
      energies.remove(entity);
    }
    entity.removeFromParent();
  }

  void addEnergy(int r, int c, int value) {
    var pos = sizeConfig.getEnemyPos(r, c, 1);
    var energy = Energy(r, c, pos.x, pos.y, value);
    energies.add(energy);
    game.addContent(energy);
    board[r][c] = energy;
    // log('addEnergy ($r,$c) $pos $value');
  }

  void dead() {
    _currentState = GameState.dead;
    game.end();
  }

  int getTowerTarget(int r, int c) {
    for (var i = 9; i >= 0; i--) {
      if (board[i][c] != null) {
        return i;
      }
    }
    return -1;
  }

  List<BoardEntity> getColEnemys(int c) {
    List<BoardEntity> result = [];
    for (var i = 9; i >= 0; i--) {
      if (board[i][c] != null) {
        result.add(board[i][c]!);
      } else if (c > 0) {
        var leftEntity = board[i][c - 1];
        if (leftEntity is Enemy && leftEntity.body == 2) {
          result.add(board[i][c - 1]!);
        }
      }
    }
    return result;
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
    for (var i = 0; i < GameConfig.row; i++) {
      for (var j = 0; j < GameConfig.col; j++) {
        s += board[i][j] != null ? '*' : '_';
      }
      s += '\n';
    }
    log(s);
  }
}
