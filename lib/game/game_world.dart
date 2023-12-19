import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/game/home.dart';
import '../config/game_config.dart';

class SCWarWorld extends World with HasGameReference<SCWarGame> {
  late HomeComponent home;
  late Component gameBg;
  @override
  Future<void> onLoad() async {
    addBg();
    // log('addbg');
  }

  void showHome() {
    home = HomeComponent();
    add(home);
  }

  void startGame() {
    home.removeFromParent();
    addGameBg();
  }

  void goToLevel() {
    if (game.playing) {
    } else {
      home.removeFromParent();
    }
  }

  void goHome() {
    if (game.playing) {
      gameBg.removeFromParent();
    }
    showHome();
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

  void addGameBg() {
    gameBg = Component();
    gameBg.priority = -1;
    add(gameBg);
    addEnemyBg();
    addTowerBg();
    gameBg.add(RectangleComponent.fromRect(
      game.gameManager.sizeConfig.getBattleFieldRect(),
      anchor: Anchor.center,
      paint: Paint()
        ..color = const Color(0x55000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10.0),
    ));
  }

  void addEnemyBg() {
    var enemyRect = game.gameManager.sizeConfig.getEnemyBgRect();
    gameBg.add(RectangleComponent.fromRect(enemyRect,
        anchor: Anchor.center, paint: paintMap['enemyBg']));
    // for (int row = 0; row < 10; row++) {
    //   for (int col = 0; col < 5; col++) {
    //     // 判断颜色
    //     Color color = (row + col) % 2 == 0
    //         ? const Color(0xFFD2E8E8)
    //         : const Color(0xFEA2A8C8);
    //     // 创建格子组件并设置位置和颜色
    //     final gridCell = RectangleComponent(
    //       position: game.gameManager.sizeConfig.getEnemyPos(row, col, 1),
    //       size: Vector2.all(GameConfig.baseBlockLen),
    //       anchor: Anchor.center,
    //       paint: Paint()..color = color,
    //     );
    //     // 将格子组件添加到 Flame 游戏中
    //     enemyBg.add(gridCell);
    //   }
    // }
  }

  void addTowerBg() {
    // final paint = Paint()..color = const Color(0xFFA8DADC);
    final rect = game.gameManager.sizeConfig.getTowerBgRect();
    gameBg.add(RectangleComponent.fromRect(rect,
        anchor: Anchor.center, paint: paintMap['towerBg']));
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < GameConfig.col; j++) {
        gameBg.add(CircleComponent(
            anchor: Anchor.center,
            radius: GameConfig.baseLen / 2,
            paint: paintMap['towerBlock'],
            position: game.gameManager.sizeConfig.getTowerPos(i, j)));
      }
    }
    gameBg.add(CircleComponent(
        anchor: Anchor.center,
        radius: GameConfig.baseLen / 2,
        paint: paintMap['preTowerBlock'],
        position: game.gameManager.sizeConfig.getPrepareTowerPos()));
    gameBg.add(CircleComponent(
        anchor: Anchor.center,
        radius: GameConfig.baseLen / 2,
        paint: Paint()
          ..color = const Color(0x441c658c)
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3.0),
        position: game.gameManager.sizeConfig.getPrepareTowerPos()));
  }
}
