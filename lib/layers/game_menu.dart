import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:scwar/game.dart';

class GameMenu extends Component with HasGameRef<SCWarGame> {
  late ScoreComponent scoreComponent;
  GameMenu();

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
  final textRenderer =
      TextPaint(style: const TextStyle(fontSize: 40, color: Colors.brown));
  PauseButton()
      : super(
          position: Vector2(500, 20),
          size: Vector2.all(80),
        );

  @override
  void onTapDown(TapDownEvent event) {
    // log('onTapDown');
    gameRef.pause();
  }

  @override
  Future<void> onLoad() async {
    final pauseText = TextComponent(
      text: '||',
      textRenderer: textRenderer,
      size: Vector2.all(80),
    );
    add(pauseText);
    return super.onLoad();
  }
}

class ScoreComponent extends PositionComponent with HasGameRef<SCWarGame> {
  late TextComponent label;
  late TextComponent score;
  final labelStyle = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1F4E79));
  final scoreStyle = const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 121, 31, 121));
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
    score.text = '${gameRef.gameManager.score}';
  }
}
