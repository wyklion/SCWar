import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:scwar/game.dart';

class GameMenu extends Component with HasGameRef<SCWarGame> {
  GameMenu();

  @override
  Future<void> onLoad() async {
    add(PauseButton());
    return super.onLoad();
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
    log('onTapDown');
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
