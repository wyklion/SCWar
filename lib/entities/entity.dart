import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';

abstract class Entity extends PositionComponent {
  int value;
  bool isCircle;
  late TextComponent text;

  Entity(double x, double y, this.isCircle, this.value) {
    size.setAll(GameConfig.baseLen);
    (Color, double) nconfig = numberMap[value] ?? (Colors.white, 1);
    this.x = x;
    this.y = y;
    final renderer =
        TextPaint(style: TextStyle(fontSize: 20, color: nconfig.$1));
    text = TextComponent(
        text: '$value',
        anchor: Anchor.center,
        textRenderer: renderer,
        scale: Vector2.all(nconfig.$2),
        size: Vector2.all(GameConfig.baseLen));
    add(text);
  }

  void renderBg(Canvas canvas);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderBg(canvas);
    // final textPainter = TextPainter(
    //   text: TextSpan(
    //     text: '$value',
    //     style: const TextStyle(color: Colors.white, fontSize: 20),
    //   ),
    //   textDirection: TextDirection.ltr,
    // )..layout();
    // textPainter.paint(
    //     canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }
}
