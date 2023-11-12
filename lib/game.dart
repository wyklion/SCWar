import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';
import 'game_manager.dart';

class SCWarGame extends FlameGame with TapDetector {
  late GameManager gameManager;
  late PositionComponent container;

  SCWarGame() {
    gameManager = GameManager(this);
  }

  @override
  FutureOr<void> onLoad() async {
    gameManager.setSize(size);
    addBg();
    // 初始化游戏元素，炮塔、敌人等
    gameManager.startGame();
    return super.onLoad();
  }

  // @override
  // void onTap() {
  //   log('tap');
  //   super.onTap();
  // }

  void addBg() {
    // 容器
    var gameSize = gameManager.size;
    final paint = Paint()..color = const Color.fromARGB(255, 222, 243, 33);
    container = RectangleComponent(
        position: Vector2((size.x - gameSize.x) / 2, 0),
        size: gameSize,
        paint: paint);
    add(container);
  }

  void addContent(content) {
    container.add(content);
  }

  @override
  Color backgroundColor() => const Color.fromARGB(0, 0, 0, 0);

  @override
  void render(Canvas canvas) {
    // var gameSize = gameManager.size;
    // final paint = Paint()..color = Color.fromARGB(255, 33, 243, 47);
    // canvas.drawRect(
    //     Rect.fromLTWH(size.x - gameSize.x, 0, gameSize.x, gameSize.y), paint);
    super.render(canvas);
  }
}
