import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'entity.dart';

enum GameState {
  Ready,
  PlayerMove,
  Shooting,
  EnemyMove,
  Dead,
}

class GameManager {
  SCWarGame game;
  int playerMoveCount = 0;
  late Tower prepareTower;
  List<Tower> towers = [];
  List<Enemy> enemies = [];
  GameState _currentState = GameState.Ready;

  GameManager(this.game) {
    towers = [];
    enemies = [];
  }

  GameState get currentState => _currentState;

  void startGame() {
    playerMoveCount = 0;
    prepareTower = Tower(200, 300, 1);
    game.add(prepareTower);
    addRandomEnemy();
    _currentState = GameState.PlayerMove;
  }

  void addRandomEnemy() {
    var enemy = Enemy(200, 100, 1);
    enemies.add(enemy);
    game.add(enemy);
  }

  void playerMove() {
    _currentState = GameState.PlayerMove;
  }

  void startShooting() {
    _currentState = GameState.Shooting;
  }

  void enemyMove() {
    _currentState = GameState.EnemyMove;
  }

  void dead() {
    _currentState = GameState.Dead;
  }

  void addTower(double x, double y, int value) {
    towers.add(Tower(x, y, value));
  }

  void addEnemy(double x, double y, int value) {
    enemies.add(Enemy(x, y, value));
  }

  void handlePlayerMove() {
    playerMoveCount++;
    // 更新炮塔和敌人的位置、数值等
  }
}

class SCWarGame extends FlameGame with TapDetector {
  late GameManager gameManager;

  SCWarGame() {
    gameManager = GameManager(this);
    init();
  }

  void init() async {
    // 初始化游戏元素，炮塔、敌人等
    gameManager.startGame();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: implement update
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
