import 'dart:async';
import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:scwar/layers/game_ui.dart';
import '../config/game_config.dart';
import 'game_manager.dart';

class SCWarGame extends FlameGame<SCWarWorld> with TapDetector, ScaleDetector {
  late GameManager gameManager;
  late PositionComponent container;
  late GameUI menu;

  SCWarGame()
      : super(
            camera: CameraComponent.withFixedResolution(
                width: GameConfig.fixedWidth, height: GameConfig.fixedHeight),
            world: SCWarWorld()) {
    gameManager = GameManager(this);
  }

  @override
  FutureOr<void> onLoad() async {
    await gameManager.load();
    overlays.add('main');
    return super.onLoad();
  }

  double get scale {
    return GameConfig.fixedWidth / camera.viewport.size.x;
  }

  // @override
  // void onTap() {
  //   log('tap');
  //   super.onTap();
  // }

  void addContent(content) {
    world.add(content);
    // log('addContent');
  }

  @override
  Color backgroundColor() => const Color.fromARGB(0, 0, 0, 0);

  void start() {
    overlays.remove('main');
    camera.viewport.add(menu = GameUI());
    world.startGame();
    gameManager.startGame();
  }

  void pause() {
    overlays.add('pause');
  }

  void resume() {
    overlays.remove('pause');
  }

  void end() {
    overlays.add('gameover');
  }

  void home() {
    gameManager.clear();
    world.clear();
    overlays.clear();
    overlays.add('main');
    menu.removeFromParent();
  }

  void restart() {
    overlays.clear();
    gameManager.restartGame();
  }

  @override
  void render(Canvas canvas) {
    // var gameSize = gameManager.size;
    // final paint = Paint()..color = Color.fromARGB(255, 33, 243, 47);
    // canvas.drawRect(
    //     Rect.fromLTWH(size.x - gameSize.x, 0, gameSize.x, gameSize.y), paint);
    super.render(canvas);
  }
}

class SCWarWorld extends World with HasGameReference<SCWarGame> {
  late RectangleComponent enemyBg;
  late Component towerBg;
  @override
  Future<void> onLoad() async {
    addBg();
    // log('addbg');
  }

  void startGame() {
    addEnemyBg();
    addTowerBg();
  }

  void clear() {
    enemyBg.removeFromParent();
    towerBg.removeFromParent();
  }

  void addBg() {
    // const gradient = LinearGradient(
    //   begin: Alignment.topCenter,
    //   end: Alignment.bottomCenter,
    //   colors: [Colors.blue, Colors.green],
    // );
    // const radiusGradient = RadialGradient(
    //   colors: [Color(0xFFB2D7D5), Color(0xFFC2C2C2)],
    //   radius: 1,
    // );
    // final rect =
    //     Rect.fromLTWH(0, 0, GameConfig.fixedWidth, GameConfig.fixedHeight);
    // final paint = Paint()..shader = radiusGradient.createShader(rect);
    // var bg = RectangleComponent(
    //     anchor: Anchor.center,
    //     position: Vector2(0, 0),
    //     size: Vector2(GameConfig.fixedWidth, GameConfig.fixedHeight),
    //     paint: paint);
    // final paint = Paint()..color = const Color(0xFF7FB3D5);
    var bg = RectangleComponent(
        anchor: Anchor.center,
        position: Vector2(0, 0),
        size: Vector2(GameConfig.fixedWidth, GameConfig.fixedHeight),
        paint: paintMap['bg']);
    bg.priority = -2;
    add(bg);
  }

  void addEnemyBg() {
    // final paint =  Paint()..color = const Color(0xFFD2E8E8);
    final enemyRect = game.gameManager.sizeConfig.getEnemyBgRect();
    enemyBg = RectangleComponent.fromRect(enemyRect,
        anchor: Anchor.center, paint: paintMap['enemyBg']);
    enemyBg.priority = -1;
    add(enemyBg);
  }

  void addTowerBg() {
    towerBg = Component();
    towerBg.priority = -1;
    add(towerBg);
    // final paint = Paint()..color = const Color(0xFFA8DADC);
    final rect = game.gameManager.sizeConfig.getTowerBgRect();
    towerBg.add(RectangleComponent.fromRect(rect,
        anchor: Anchor.center, paint: paintMap['towerBg']));
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < GameConfig.col; j++) {
        towerBg.add(CircleComponent(
            anchor: Anchor.center,
            radius: GameConfig.baseLen / 2,
            paint: paintMap['towerBlock'],
            position: game.gameManager.sizeConfig.getTowerPos(i, j)));
      }
    }
    towerBg.add(CircleComponent(
        anchor: Anchor.center,
        radius: GameConfig.baseLen / 2,
        paint: paintMap['preTowerBlock'],
        position: game.gameManager.sizeConfig.getPrepareTowerPos()));
  }
}