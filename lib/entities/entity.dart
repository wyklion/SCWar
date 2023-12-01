import 'dart:async';
import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:scwar/game_manager.dart';
import 'package:scwar/utils/unit_util.dart';
import '../game.dart';
import '../game_config.dart';

abstract class Entity extends PositionComponent with HasGameRef<SCWarGame> {
  final int score;
  int value;
  late EntityType type;
  late TextComponent text;
  late GameManager gameManager;

  Entity(double x, double y, this.score) : value = score {
    size.setAll(GameConfig.baseLen);
    this.x = x;
    this.y = y;
  }

  @override
  FutureOr<void> onLoad() {
    (Color, double) nconfig = numberMap[value] ?? (Colors.white, 1);
    final renderer =
        TextPaint(style: TextStyle(fontSize: 20, color: nconfig.$1));
    text = TextComponent(
        text: getDisplay(),
        anchor: Anchor.center,
        textRenderer: renderer,
        scale: Vector2.all(nconfig.$2),
        size: Vector2.all(GameConfig.baseLen));
    add(text);
    gameManager = gameRef.gameManager;
    return super.onLoad();
  }

  String getDisplay({int? value}) {
    var v = value ?? this.value;
    return UnitUtil.convertValue(v, 1);
  }

  void setValue(int value) {
    this.value = value;
    text.text = getDisplay();
  }

  void setTextValue(int value) {
    text.text = getDisplay(value: value);
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

abstract class BoardEntity extends Entity {
  int r;
  int c;
  int body;
  BoardEntity(this.r, this.c, double x, double y, this.body, int value)
      : super(x, y, value);

  Future<bool> moveOneStep() async {
    if (r + 1 == 10) {
      moveToEnd();
      return false;
    }
    r++;
    var pos = gameManager.sizeConfig.getEnemyPos(r, c, body);
    y = pos.y;
    return true;
  }

  Future<void> takeDamage(int damage);

  void moveToEnd() {
    log('entity move to end $r $c');
    gameManager.removeBoardEntity(this);
  }

  void dead() {
    gameManager.removeBoardEntity(this);
  }
}
