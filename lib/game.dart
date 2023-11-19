import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';
import 'package:scwar/entities/energy.dart';
import 'package:scwar/layers/game_menu.dart';
import 'package:scwar/utils/sound_manager.dart';
import 'game_config.dart';
import 'game_manager.dart';

class SCWarGame extends FlameGame<SCWarWorld> with TapDetector, ScaleDetector {
  late GameManager gameManager;
  late PositionComponent container;
  late GameMenu menu;

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
    camera.viewport.add(menu = GameMenu());
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
  late RectangleComponent towerBg;
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
    const radiusGradient = RadialGradient(
      colors: [Colors.lightBlueAccent, Colors.blueGrey],
      radius: 1,
    );
    final rect =
        Rect.fromLTWH(0, 0, GameConfig.fixedWidth, GameConfig.fixedHeight);
    final paint = Paint()..shader = radiusGradient.createShader(rect);
    // final paint = Paint()..color = const Color.fromARGB(255, 222, 243, 33);
    var bg = RectangleComponent(
        anchor: Anchor.center,
        position: Vector2(0, 0),
        size: Vector2(GameConfig.fixedWidth, GameConfig.fixedHeight),
        paint: paint);
    bg.priority = -2;
    add(bg);
  }

  void addEnemyBg() {
    final paint = Paint()..color = const Color.fromARGB(255, 33, 236, 243);
    final enemyRect = game.gameManager.sizeConfig.getEnemyBgRect();
    enemyBg = RectangleComponent.fromRect(enemyRect,
        anchor: Anchor.center, paint: paint);
    enemyBg.priority = -1;
    add(enemyBg);
  }

  void addTowerBg() {
    final paint = Paint()..color = const Color.fromARGB(255, 160, 106, 200);
    final rect = game.gameManager.sizeConfig.getTowerBgRect();
    towerBg =
        RectangleComponent.fromRect(rect, anchor: Anchor.center, paint: paint);
    towerBg.priority = -1;
    add(towerBg);
  }
}
