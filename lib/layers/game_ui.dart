import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:scwar/game/game.dart';
import 'package:scwar/utils/number_util.dart';

class GameUI extends Component with HasGameRef<SCWarGame> {
  late ScoreComponent scoreComponent;
  GameUI();

  @override
  Future<void> onLoad() async {
    add(PauseButton());
    add(scoreComponent = ScoreComponent());
    return super.onLoad();
  }

  void updateScore() {
    scoreComponent.updateScore();
  }
}

class PauseButton extends PositionComponent
    with HasGameRef<SCWarGame>, TapCallbacks {
  // final textRenderer = TextPaint(
  //     style: const TextStyle(
  //         fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFF3B5998)));
  PauseButton()
      : super(
          position: Vector2(470, 5),
          size: Vector2.all(64),
          // anchor: Anchor.center,
        );

  @override
  void onTapDown(TapDownEvent event) {
    // log('onTapDown');
    gameRef.gameManager.soundManager.playCick();
    gameRef.pause();
  }

  @override
  Future<void> onLoad() async {
    var img = Flame.images.fromCache('pause_icon.png');
    final sprite = Sprite(img);
    final btn = SpriteComponent(
      size: Vector2.all(64),
      sprite: sprite,
      // anchor: Anchor.center,
    );
    add(btn);
    // final pauseText = TextComponent(
    //   text: '||',
    //   textRenderer: textRenderer,
    //   size: Vector2.all(80),
    // );
    // add(pauseText);
    return super.onLoad();
  }
}

class ScoreComponent extends PositionComponent with HasGameRef<SCWarGame> {
  late TextComponent label;
  late TextComponent score;
  final labelStyle = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF0f4c75));
  final scoreStyle = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFFFFE9A3));
  ScoreComponent()
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
    return super.onLoad();
  }

  void updateScore() {
    score.text = NumberUtil.getScoreString(gameRef.gameManager.score);
  }
}
