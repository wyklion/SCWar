import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';
import 'package:scwar/entities/energy.dart';
import 'package:scwar/layers/game_menu.dart';
import 'game_config.dart';
import 'game_manager.dart';

class SCWarGame extends FlameGame with TapDetector, ScaleDetector {
  late GameManager gameManager;
  late PositionComponent container;

  SCWarGame()
      : super(
            camera: CameraComponent.withFixedResolution(
                width: GameConfig.fixedWidth, height: GameConfig.fixedHeight),
            world: SCWarWorld()) {
    gameManager = GameManager(this);
  }

  @override
  FutureOr<void> onLoad() async {
    gameManager.onLoad();
    gameManager.startGame();
    camera.viewport.add(GameMenu());
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

  void pause() {
    overlays.add('pause');
  }

  void resume() {
    overlays.remove('pause');
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

class SCWarWorld extends World with HasGameReference {
  @override
  Future<void> onLoad() async {
    addBg();
    // log('addbg');
  }

  void addBg() {
    final paint = Paint()..color = const Color.fromARGB(255, 222, 243, 33);
    var bg = RectangleComponent(
        anchor: Anchor.center,
        position: Vector2(0, 0),
        size: Vector2(GameConfig.fixedWidth, GameConfig.fixedHeight),
        paint: paint);
    bg.priority = -1;
    add(bg);
  }
}
