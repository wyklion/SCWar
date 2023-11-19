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
  final textRenderer = TextPaint(
      style: const TextStyle(
          fontSize: 30, color: Color.fromARGB(196, 238, 97, 46)));
  ScoreComponent()
      : super(
          position: Vector2(480, 120),
          size: Vector2.all(180),
        );

  @override
  Future<void> onLoad() async {
    label = TextComponent(
      anchor: Anchor.center,
      text: 'Score',
      textRenderer: textRenderer,
      size: Vector2(180, 80),
    );
    add(label);
    score = TextComponent(
      anchor: Anchor.center,
      text: '0',
      textRenderer: textRenderer,
      size: Vector2(380, 80),
      position: Vector2(0, 80),
    );
    add(score);
    return super.onLoad();
  }

  void updateScore() {
    score.text = '${gameRef.gameManager.score}';
  }
}
