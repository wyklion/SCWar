import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:scwar/utils/local_storage.dart';
import 'package:scwar/utils/particles.dart';
import 'package:scwar/utils/sound_manager.dart';
import '../entities/energy.dart';
import '../entities/entity.dart';
import '../entities/enemy.dart';
import '../entities/tower.dart';
import 'game.dart';
import '../config/game_config.dart';
import '../utils/generator.dart';
import '../utils/size_config.dart';

enum GameState {
  ready,
  playerMove,
  shooting,
  enemyMove,
  enemyCreate,
  gameOver,
}

class GameManager {
  SCWarGame game;
  Tower? prepareTower;
  List<List<BoardEntity?>> board = [];
  List<Tower> towers = [];
  List<Enemy> enemies = [];
  List<Energy> energies = [];
  List<double> preMerges = [];
  int playerMoveCount = 0;
  double towerPower = 0;
  double bigTower = 0;
  double score = 0;
  GameState _currentState = GameState.ready;
  int _attackCount = 0;
  Completer? _attackCompleter;
  late SizeConfig sizeConfig;
  late Generator generator;
  final math.Random random = math.Random();
  final Particles particles = Particles();
  SoundManager soundManager = SoundManager();
  late LocalStorage localStorage;

  GameManager(this.game) {
    for (var i = 0; i < GameConfig.row; i++) {
      var row = List<BoardEntity?>.filled(GameConfig.col, null);
      board.add(row);
    }
    generator = Generator(this);
  }

  Future<void> load() async {
    sizeConfig = SizeConfig(game.size);
    await Flame.images.loadAll([
      // 'blue.png',
      'pause_icon.png',
    ]);
    await loadStorage();
    await soundManager.load();
    setSoundOn(localStorage.getSoundOn());
  }

  void setSoundOn(bool on) {
    soundManager.soundOn = on;
    localStorage.setSoundOn(on);
  }

  Future<void> loadStorage() async {
    localStorage = await LocalStorage.getInstance();
  }

  void saveGame() {
    var j = toJson();
    localStorage.setGameJson(j);
  }

  Map<String, dynamic> toJson() {
    dynamic json = {
      'score': score,
      'moveCount': score,
      'preTower': prepareTower == null ? 0 : prepareTower!.value,
      'towers': [],
      'board': [],
    };
    for (var i = 0; i < towers.length; i++) {
      var t = towers[i];
      json['towers'].add([t.r, t.c, t.value]);
    }
    for (var i = 0; i < board.length; i++) {
      for (var j = 0; j < board[i].length; j++) {
        var b = board[i][j];
        if (b is Enemy) {
          json['board'].add([b.r, b.c, 1, b.value, b.body]);
        } else if (b is Energy) {
          int et = b.type == EntityType.energy ? 2 : 3;
          json['board'].add([b.r, b.c, et, b.value]);
        }
      }
    }
    return json;
  }

  bool loadGame() {
    final json = localStorage.getGameJson();
    if (json == null) {
      return false;
    }
    clear();
    score = json['score'];
    game.menu.updateScore();
    playerMoveCount = json['moveCount'];
    var preT = json['preTower'];
    if (preT > 0) {
      addPrepareTower(preT);
    }
    var jboard = json['board'];
    for (var i = 0; i < jboard.length; i++) {
      var b = jboard[i];
      if (b[2] == 1) {
        addEnemy(b[0], b[1], b[3], b[4]);
      } else if (b[2] == 2 || b[2] == 3) {
        addEnergy(b[0], b[1], b[3],
            b[2] == 2 ? EntityType.energy : EntityType.energyMultiply);
      }
    }
    var jtowers = json['towers'];
    for (var i = 0; i < jtowers.length; i++) {
      var t = jtowers[i];
      addTower(t[0], t[1], t[2]);
    }
    _currentState = GameState.playerMove;
    return true;
  }

  Vector2 get size => sizeConfig.size;

  GameState get currentState => _currentState;

  void test() {
    // score = 3523511;
    // game.menu.updateScore();
    // addTower(0, 0, 4);
    // addTower(0, 1, 2048);
    // addTower(0, 2, 8);
    // addTower(0, 3, 2);
    // addTower(0, 4, 8);
    // addTower(0, 0, 262144);
    // addTower(0, 1, 131072);
    // addTower(0, 2, 8192);
    // addTower(0, 4, 16384);
    // addTower(1, 3, 524288);
    // addTower(1, 0, 1.2e32);
    // addTower(1, 1, 1.2e90);
    // addTower(1, 2, 1.2e168);
    // addEnergy(2, 1, 2, EntityType.energyMultiply);
    // addEnergy(3, 1, 2, EntityType.energyMultiply);
    // addEnergy(2, 0, 2, EntityType.energy);
    // addEnemy(3, 0, 8, 1);
    // addEnergy(4, 0, 2, EntityType.energy);
    // addEnemy(5, 0, 1, 1);
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
      case GameState.gameOver:
        gameOver();
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
    bigTower = 0;
    score = 0;
    game.menu.updateScore();
    _currentState = GameState.ready;
  }

  void restartGame() {
    localStorage.removeGame();
    clear();
    startGame(newGame: true);
  }

  void startGame({bool newGame = false}) {
    generator.init();
    // 加载之前游戏
    if (!newGame && loadGame()) {
      return;
    }
    // 新游戏
    test();
    addPrepareTower(1);
    addRandomEnemy();
  }

  void playerMove() {
    saveGame();
  }

  void startShooting() async {
    soundManager.playShoot();
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
    preMerges.clear();
    // mergePrepareTower();
    setState(GameState.enemyMove);
  }

  Future<void> attackEnemy(int r, int c, double attack) async {
    // log('attackEnemy $r, $c, $attack');
    _attackCount++;
    var entity = board[r][c];
    if (entity is Enemy) {
      soundManager.playHurt();
      await entity.takeDamage(attack);
    } else if (entity is Energy) {
      soundManager.playEnergy();
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
    List<Enemy> beatEnemies = [];
    for (var i = 0; i < GameConfig.col; i++) {
      if (board[GameConfig.row - 1][i] is Enemy) {
        beatEnemies.add(board[GameConfig.row - 1][i] as Enemy);
      }
      if (board[GameConfig.row - 2][i] is Enemy) {
        Enemy enemy = board[GameConfig.row - 2][i] as Enemy;
        if (enemy.body == 2) {
          beatEnemies.add(enemy);
        }
      }
    }
    List<Future<void>> tasks = [];
    if (beatEnemies.isNotEmpty) {
      for (var i = 0; i < beatEnemies.length; i++) {
        tasks.add(beatEnemies[i].beat());
      }
      await Future.wait(tasks);
      setState(GameState.gameOver);
      return;
    }
    for (var j = 0; j < GameConfig.col; j++) {
      for (var i = GameConfig.row - 1; i >= 0; i--) {
        var entity = board[i][j];
        if (entity != null) {
          board[i][j] = null;
          if (i < 9) {
            board[i + 1][j] = entity;
          }
          tasks.add(entity.moveOneStep());
        }
      }
    }
    // List<Future<bool>> tasks = [];
    // for (var enemy in enemies) {
    //   board[enemy.r][enemy.c] = null;
    //   if (enemy.r < 9) {
    //     board[enemy.r + 1][enemy.c] = enemy;
    //   }
    //   tasks.add(enemy.moveOneStep());
    // }
    // for (var energy in energies) {
    //   board[energy.r][energy.c] = null;
    //   if (energy.r < 9) {
    //     board[energy.r + 1][energy.c] = energy;
    //   }
    //   tasks.add(energy.moveOneStep());
    // }
    tasks.add(addRandomEnemy());
    await Future.wait(tasks);
  }

  Future<void> addRandomEnemy() async {
    _currentState = GameState.enemyCreate;
    var row = generator.getNextRow();
    List<Future<void>> tasks = [];
    for (var i = 0; i < GameConfig.col; i++) {
      var info = row[i];
      if (info.type == EntityType.enemy) {
        if (info.value > 0) {
          tasks.add(addEnemy(0, i, info.value, info.size));
        }
      } else if (info.type != EntityType.empty) {
        tasks.add(addEnergy(0, i, info.value, info.type));
      }
    }
    await Future.wait(tasks);
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

  void addPreMerge(double value) {
    preMerges.add(value);
  }

  void onEnergyArrived(Energy energy) {
    if (prepareTower == null) {
      addPrepareTower(energy.value);
      preMerges.remove(energy.value);
      return;
    }
    double s = prepareTower!.value;
    double big = prepareTower!.value;
    for (var m in preMerges) {
      s += m;
      if (m > big) {
        big = m;
      }
    }
    // 合并资源
    while (big * 2 <= s) {
      big *= 2;
    }
    prepareTower!.setValue(big);
  }

  void mergePrepareTower() {
    if (preMerges.isEmpty) {
      return;
    }
    double s = 0;
    double big = 0;
    for (var m in preMerges) {
      s += m;
      if (m > big) {
        big = m;
      }
    }
    preMerges.clear();
    Tower tower;
    if (prepareTower is Tower) {
      tower = prepareTower!;
      s += tower.value;
      if (tower.value >= big) {
        big = tower.value;
      }
    }
    // 合并资源
    while (big * 2 <= s) {
      big *= 2;
    }
    if (prepareTower is Tower) {
      prepareTower!.setValue(big);
    } else {
      addPrepareTower(big);
    }
  }

  get prepareTowerPos => sizeConfig.getPrepareTowerPos();

  void addPrepareTower(double value) {
    var pos = prepareTowerPos;
    prepareTower = Tower(-1, -1, pos.x, pos.y, value);
    game.addContent(prepareTower);
    // log('addPrepareTower $pos $value');
  }

  void addTower(int r, int c, double value) {
    var pos = sizeConfig.getTowerPos(r, c);
    var tower = Tower(r, c, pos.x, pos.y, value);
    towers.add(tower);
    towerPower += value;
    if (value > bigTower) {
      bigTower = value;
    }
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
      if (tower.value > bigTower) {
        bigTower = tower.value;
      }
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
      towerPower += (tower1.value - tower2.value);
      prepareTower = tower2;
      towers.remove(tower2);
      towers.add(tower1);
      // 这种交换情况重算一下
      if (tower1.value < tower2.value) {
        bigTower = 0;
        for (var i = 0; i < towers.length; i++) {
          if (towers[i].value > bigTower) {
            bigTower = towers[i].value;
          }
        }
      }
    }
    setState(GameState.shooting);
  }

  void doubleTower(Tower tower) {
    soundManager.playMerge();
    towerPower += tower.value;
    tower.upgrade();
    if (tower.value > bigTower) {
      bigTower = tower.value;
    }
  }

  void upgradeTower(Tower tower, bool fromPrepare) {
    soundManager.playMerge();
    if (fromPrepare) {
      towerPower += tower.value;
    }
    tower.upgrade();
    if (tower.value > bigTower) {
      bigTower = tower.value;
    }
    setState(GameState.shooting);
  }

  Future<void> addEnemy(int r, int c, double value, int body) async {
    if (board[r][c] != null) {
      return;
    }
    var pos = sizeConfig.getEnemyPos(r, c, body);
    var enemy = Enemy(r, c, pos.x, pos.y, value, body);
    enemies.add(enemy);
    game.addContent(enemy);
    board[r][c] = enemy;
    await enemy.createShow();
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

  Future<void> addEnergy(int r, int c, double value, EntityType type) async {
    var pos = sizeConfig.getEnemyPos(r, c, 1);
    var energy = Energy(r, c, pos.x, pos.y, value, type);
    energies.add(energy);
    game.addContent(energy);
    board[r][c] = energy;
    await energy.createShow();
    // log('addEnergy ($r,$c) $pos $value');
  }

  void gameOver() async {
    soundManager.playDead();
    localStorage.removeGame();
    var high = localStorage.getHighScore();
    if (score > high) {
      localStorage.setHighScore(score);
    }
    await Future.delayed(const Duration(milliseconds: 500));
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