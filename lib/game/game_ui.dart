import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/config/game_config.dart';
import 'dart:developer';
import 'package:scwar/game/game.dart';
import 'package:scwar/utils/number_util.dart';

class GameUI extends Component with HasGameRef<SCWarGame> {
  late DataComponent scoreComponent;
  LevelComponent? levelComponent;
  GameUI();

  @override
  Future<void> onLoad() async {
    // add(PauseButton());
    add(scoreComponent = DataComponent());
    return super.onLoad();
  }

  void updateAll() {
    updateScore();
    updatePlayerData();
    updateEnemyData();
  }

  void updateScore() {
    scoreComponent.updateScore();
  }

  void updatePlayerData() {
    scoreComponent.updatePlayerData();
  }

  void updateEnemyData() {
    scoreComponent.updateEnemyData();
  }

  void setupLevel() {
    if (game.gameManager.level > 0) {
      if (levelComponent != null) {
        levelComponent!.removeFromParent();
      }
      add(levelComponent = LevelComponent());
    }
  }

  void updateLevelData() {
    if (game.gameManager.level > 0) {
      levelComponent!.updatePower();
    }
  }
}

// class PauseButton extends PositionComponent
//     with HasGameRef<SCWarGame>, TapCallbacks {
//   // final textRenderer = TextPaint(
//   //     style: const TextStyle(
//   //         fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFF3B5998)));
//   PauseButton()
//       : super(
//           position: Vector2(470, 5),
//           size: Vector2.all(64),
//           // anchor: Anchor.center,
//         );

//   @override
//   void onTapDown(TapDownEvent event) {
//     // log('onTapDown');
//     gameRef.gameManager.soundManager.playCick();
//     gameRef.pause();
//   }

//   @override
//   Future<void> onLoad() async {
//     var img = Flame.images.fromCache('pause_icon.png');
//     final sprite = Sprite(img);
//     final btn = SpriteComponent(
//       size: Vector2.all(64),
//       sprite: sprite,
//       // anchor: Anchor.center,
//     );
//     add(btn);
//     // final pauseText = TextComponent(
//     //   text: '||',
//     //   textRenderer: textRenderer,
//     //   size: Vector2.all(80),
//     // );
//     // add(pauseText);
//     return super.onLoad();
//   }
// }

class LevelComponent extends PositionComponent with HasGameRef<SCWarGame> {
  late TextComponent power;
  late RectangleComponent powerRect;
  LevelComponent()
      : super(
          position: Vector2(470, 100),
        );

  @override
  Future<void> onLoad() async {
    String? levelText = '${game.locale?.level} ${game.gameManager.level}';
    double scale = 1;
    if (levelText.length > 9) {
      scale = 0.65;
    } else if (levelText.length > 8) {
      scale = 0.8;
    } else if (levelText.length == 8) {
      scale = 0.9;
    }
    add(TextComponent(
      anchor: Anchor.center,
      text: levelText,
      textRenderer: TextPaint(
        style: TextStyleMap.label,
      ),
      size: Vector2(120, 50),
      scale: Vector2.all(scale),
      position: Vector2(0, 0),
    ));
    add(TextComponent(
      anchor: Anchor.center,
      text: game.locale?.targetPower,
      textRenderer: TextPaint(
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3B5998)),
      ),
      size: Vector2(160, 15),
      position: Vector2(0, 40),
    ));
    add(RectangleComponent(
      anchor: Anchor.center,
      size: Vector2(110, 20),
      paint: Paint()..color = const Color(0xFFD2E8E8),
      position: Vector2(0, 65),
    ));
    add(powerRect = RectangleComponent(
      anchor: Anchor.centerLeft,
      size: Vector2(110, 20),
      paint: Paint()..color = const Color(0xFF7DCEA0),
      position: Vector2(-55, 65),
    ));
    add(
      power = TextComponent(
        anchor: Anchor.center,
        text: '',
        textRenderer: TextPaint(
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B5998)),
        ),
        size: Vector2(160, 20),
        position: Vector2(0, 65),
      ),
    );
    updatePower();
  }

  String getPowerString() {
    String current =
        NumberUtil.convertValue(game.gameManager.data.towerPower, 1);
    String target = NumberUtil.convertValue(game.gameManager.levelTarget, 1);
    return '$current / $target';
  }

  void updatePower() {
    double ratio =
        game.gameManager.data.towerPower / game.gameManager.levelTarget;
    powerRect.scale.x = ratio > 1 ? 1 : ratio;
    power.text = getPowerString();
  }
}

class DataComponent extends PositionComponent with HasGameRef<SCWarGame> {
  late TextComponent label;
  late TextComponent score;
  late TextComponent playerMoveCount;
  late TextComponent level;
  late TextComponent enemyCount;
  late TextComponent energyCount;
  late TextComponent energyMultiplyCount;
  late TextComponent moveCount;
  late TextComponent swapCount;
  late TextComponent mergeCount;
  final labelStyle = const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1F4E79),
      shadows: [
        Shadow(
          blurRadius: 2,
          color: Color(0x88000000),
          offset: Offset(2, 2),
        )
      ]);
  final scoreStyle = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: ColorMap.score);
  DataComponent()
      : super(
          position: Vector2(470, 220),
          size: Vector2.all(180),
        );

  @override
  Future<void> onLoad() async {
    String scoreText = '${game.locale?.score}';
    double scale = 1;
    if (scoreText.length > 9) {
      scale = 0.65;
    } else if (scoreText.length > 8) {
      scale = 0.8;
    } else if (scoreText.length == 8) {
      scale = 0.9;
    }
    label = TextComponent(
      anchor: Anchor.center,
      text: scoreText,
      textRenderer: TextPaint(style: TextStyleMap.label),
      size: Vector2(180, 80),
      scale: Vector2.all(scale),
    );
    add(label);
    score = TextComponent(
      anchor: Anchor.center,
      text: '0',
      textRenderer: TextPaint(style: scoreStyle),
      size: Vector2(380, 80),
      position: Vector2(0, 50),
    );
    add(score);
    if (Config.testMode) {
      playerMoveCount = addData('Shoot', 1);
      level = addData('Level', 2);
      enemyCount = addData('Enemy', 3);
      energyCount = addData('Energy', 4);
      energyMultiplyCount = addData('x2', 5);
      moveCount = addData('Move', 6);
      swapCount = addData('Swap', 7);
      mergeCount = addData('Merge', 8);
    }
    return super.onLoad();
  }

  TextComponent addData(String label, int idx) {
    add(TextComponent(
      anchor: Anchor.centerRight,
      text: label,
      textRenderer: TextPaint(style: TextStyleMap.dataLabel),
      size: Vector2(160, 80),
      position: Vector2(0, 100 + idx * 30),
    ));
    var text = TextComponent(
      anchor: Anchor.centerLeft,
      text: '0',
      textRenderer: TextPaint(style: TextStyleMap.data),
      size: Vector2(380, 80),
      position: Vector2(10, 100 + idx * 30),
    );
    add(text);
    return text;
  }

  void updateScore() {
    score.text = NumberUtil.getScoreString(gameRef.gameManager.data.score);
  }

  void updatePlayerData() {
    if (Config.testMode) {
      playerMoveCount.text = '${gameRef.gameManager.data.playerMoveCount}';
      level.text = '${gameRef.gameManager.data.baseLevel}';
      moveCount.text = '${gameRef.gameManager.data.moveCount}';
      swapCount.text = '${gameRef.gameManager.data.swapCount}';
      mergeCount.text = '${gameRef.gameManager.data.mergeCount}';
    }
  }

  void updateEnemyData() {
    if (Config.testMode) {
      enemyCount.text = '${gameRef.gameManager.data.enemyCount}';
      energyCount.text = '${gameRef.gameManager.data.energyCount}';
      energyMultiplyCount.text =
          '${gameRef.gameManager.data.energyMultiplyCount}';
    }
  }
}
