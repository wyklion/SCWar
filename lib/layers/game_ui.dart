import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:scwar/game/game.dart';
import 'package:scwar/utils/number_util.dart';

class GameUI extends Component with HasGameRef<SCWarGame> {
  late DataComponent scoreComponent;
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
      fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFFFCF3CF));
  final scoreStyle = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFFFFCD00));
  final dataLabelStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD3E2F2));
  final dataStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF6D7993));
  DataComponent()
      : super(
          position: Vector2(470, 220),
          size: Vector2.all(180),
        );

  @override
  Future<void> onLoad() async {
    label = TextComponent(
      anchor: Anchor.center,
      text: 'SCORE',
      textRenderer: TextPaint(style: labelStyle),
      size: Vector2(180, 80),
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
    playerMoveCount = addData('Shoot', 1);
    level = addData('Level', 2);
    enemyCount = addData('Enemy', 3);
    energyCount = addData('Energy', 4);
    energyMultiplyCount = addData('x2', 5);
    moveCount = addData('Move', 6);
    swapCount = addData('Swap', 7);
    mergeCount = addData('Merge', 8);
    return super.onLoad();
  }

  TextComponent addData(String label, int idx) {
    add(TextComponent(
      anchor: Anchor.centerRight,
      text: label,
      textRenderer: TextPaint(style: dataLabelStyle),
      size: Vector2(180, 80),
      position: Vector2(0, 100 + idx * 30),
    ));
    var text = TextComponent(
      anchor: Anchor.centerLeft,
      text: '0',
      textRenderer: TextPaint(style: dataStyle),
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
    playerMoveCount.text = '${gameRef.gameManager.data.playerMoveCount}';
    level.text = '${gameRef.gameManager.data.baseLevel}';
    moveCount.text = '${gameRef.gameManager.data.moveCount}';
    swapCount.text = '${gameRef.gameManager.data.swapCount}';
    mergeCount.text = '${gameRef.gameManager.data.mergeCount}';
  }

  void updateEnemyData() {
    enemyCount.text = '${gameRef.gameManager.data.enemyCount}';
    energyCount.text = '${gameRef.gameManager.data.energyCount}';
    energyMultiplyCount.text =
        '${gameRef.gameManager.data.energyMultiplyCount}';
  }
}
