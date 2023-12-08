import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:scwar/game/game_data.dart';
import 'package:scwar/game/game_test.dart';
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

enum GameType {
  endless,
  level,
}

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
  // 无尺模式是0。其他是关卡
  int level = 0;
  double levelTarget = 0;
  Tower? prepareTower;
  List<List<BoardEntity?>> board = [];
  List<Tower> towers = [];
  List<Enemy> enemies = [];
  List<Energy> energies = [];
  double preMergeTotal = 0;
  GameData data = GameData();
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
    localStorage = game.localStorage;
    sizeConfig = SizeConfig(game.size);
    await Flame.images.loadAll([
      // 'blue.png',
      'pause_icon.png',
    ]);
    await soundManager.load();
    setSoundOn(localStorage.getSoundOn());
  }

  void setSoundOn(bool on) {
    soundManager.soundOn = on;
    localStorage.setSoundOn(on);
  }

  void saveGame() {
    var j = toJson();
    localStorage.setGameJson(j);
  }

  Map<String, dynamic> toJson() {
    dynamic json = {
      'preTower': prepareTower == null ? 0 : prepareTower!.value,
      'towers': [],
      'board': [],
    };
    data.saveJson(json);
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
    dynamic json;
    if (GameTest.enable) {
      json = GameTest.data;
    } else {
      json = localStorage.getGameJson();
    }
    if (json == null) {
      return false;
    }
    clear();

    data.loadJson(json);
    game.ui.updateAll();
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
    data.computeInit();
    _currentState = GameState.playerMove;
    return true;
  }

  Vector2 get size => sizeConfig.size;

  GameState get currentState => _currentState;

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
      prepareTower = null;
    }
    for (var i = 0; i < GameConfig.row; i++) {
      for (var j = 0; j < GameConfig.col; j++) {
        board[i][j] = null;
      }
    }
    preMergeTotal = 0;
    data.clear();
    game.ui.updateAll();
    _currentState = GameState.ready;
  }

  void restartGame() {
    if (level == 0) {
      localStorage.removeGame();
    }
    clear();
    startGame(newGame: true, level: level);
  }

  void startGame({bool newGame = false, int level = 0}) {
    this.level = level;
    generator.init();
    // 加载之前游戏，只有无尽模式有记录
    if (!newGame && level == 0 && loadGame()) {
      return;
    }
    // 新游戏
    if (level == 0) {
      addPrepareTower(1);
      addRandomEnemy();
    } else {
      double initTowerValue = math.pow(1024, level).toDouble();
      levelTarget = initTowerValue * 1024;
      addTower(1, 0, initTowerValue);
      addTower(1, 2, initTowerValue);
      addTower(1, 4, initTowerValue);
      data.computeInit();
      addRandomEnemy();
      game.ui.setupLevel();
    }
  }

  void playerMove() {
    game.ui.updateEnemyData();
    game.ui.updateLevelData();
    // 只有无尽模式保存游戏。
    if (level == 0) {
      if (data.playerMoveCount > 0) {
        saveGame();
      }
    } else {
      if (data.towerPower >= levelTarget) {
        setState(GameState.gameOver);
      }
    }
  }

  void startShooting() async {
    soundManager.playShoot();
    data.computeMove();
    game.ui.updatePlayerData();
    game.ui.updateLevelData();
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
    preMergeTotal = prepareTower != null ? prepareTower!.value : 0;
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
    setState(GameState.playerMove);
  }

  void onEnergyArrived(Energy energy) {
    var newValue = energy.value;
    preMergeTotal += newValue;
    if (prepareTower == null) {
      addPrepareTower(newValue);
      return;
    }
    double big = prepareTower!.value;
    if (newValue > big) {
      big = newValue;
    }
    // 合并资源
    while (big * 2 <= preMergeTotal) {
      big *= 2;
    }
    prepareTower!.setValue(big);
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
    data.addTower(value);
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
    data.moveCount++;
    soundManager.playMove();
    if (tower == prepareTower) {
      prepareTower = null;
      towers.add(tower);
      data.addTower(tower.value);
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
    data.swapCount++;
    soundManager.playSwap();
    var tempR = tower1.r;
    var tempC = tower1.c;
    tower1.setPos(tower2.r, tower2.c);
    tower2.setPos(tempR, tempC);
    if (tower1 == prepareTower) {
      prepareTower = tower2;
      towers.remove(tower2);
      towers.add(tower1);
      data.towerPower += (tower1.value - tower2.value);
      // 这种交换情况重算一下
      if (tower1.value < tower2.value) {
        data.bigTower = 0;
        for (var i = 0; i < towers.length; i++) {
          if (towers[i].value > data.bigTower) {
            data.bigTower = towers[i].value;
          }
        }
      }
    }
    setState(GameState.shooting);
  }

  void mergeTower(Tower tower, Tower other) {
    data.mergeCount++;
    soundManager.playMerge();
    var merge = other != prepareTower;
    removeTower(other);
    data.upgradeTower(tower.value, merge: merge);
    tower.upgrade();
    setState(GameState.shooting);
  }

  void doubleTower(Tower tower) {
    soundManager.playMerge();
    data.upgradeTower(tower.value);
    tower.upgrade();
  }

  Future<void> addEnemy(int r, int c, double value, int body) async {
    if (board[r][c] != null) {
      return;
    }
    var pos = sizeConfig.getEnemyPos(r, c, body);
    var enemy = Enemy(r, c, pos.x, pos.y, value, body: body);
    enemies.add(enemy);
    game.addContent(enemy);
    board[r][c] = enemy;
    await enemy.createShow();
    // log('addEnemy ($r,$c) $pos $value');
  }

  void removeBoardEntity(BoardEntity entity, bool dead) {
    board[entity.r][entity.c] = null;
    if (entity is Enemy) {
      data.enemyCount++;
      enemies.remove(entity);
      // 杀怪加分
      data.score += entity.score;
      game.ui.updateScore();
    } else if (entity is Energy) {
      if (dead) {
        if (entity.type == EntityType.energy) {
          data.energyCount++;
        } else if (entity.type == EntityType.energyMultiply) {
          data.energyMultiplyCount++;
        }
      }
      energies.remove(entity);
    }
    entity.removeFromParent();
  }

  Future<void> addEnergy(int r, int c, double value, EntityType type) async {
    var pos = sizeConfig.getEnemyPos(r, c, 1);
    var energy = Energy(r, c, pos.x, pos.y, value, type: type);
    energies.add(energy);
    game.addContent(energy);
    board[r][c] = energy;
    await energy.createShow();
    // log('addEnergy ($r,$c) $pos $value');
  }

  void gameOver() async {
    bool win = false;
    if (level == 0) {
      localStorage.removeGame();
    } else {
      if (data.towerPower >= levelTarget) {
        win = true;
      }
    }
    if (win) {
      soundManager.playWin();
    } else {
      soundManager.playDead();
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
