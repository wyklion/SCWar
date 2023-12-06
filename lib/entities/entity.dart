import 'dart:async';
import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:scwar/game/game_manager.dart';
import 'package:scwar/utils/number_util.dart';
import '../game/game.dart';
import '../config/game_config.dart';

abstract class Entity extends PositionComponent
    with HasGameRef<SCWarGame>, HasPaint {
  final double score;
  double value;
  bool isValid = true;
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

  String getDisplay({double? value}) {
    var v = value ?? this.value;
    return NumberUtil.convertValue(v, 1);
  }

  void setValue(double value) {
    this.value = value;
    text.text = getDisplay();
  }

  void setTextValue(double value) {
    text.text = getDisplay(value: value);
  }
}

abstract class BoardEntity extends Entity {
  int r;
  int c;
  int body;
  BoardEntity(this.r, this.c, double x, double y, this.body, double value)
      : super(x, y, value);

  Future<void> createShow() async {
    scale.setAll(0);
    final effect = ScaleEffect.to(
      Vector2.all(1),
      EffectController(
        duration: 0.3,
        curve: Curves.easeIn,
      ),
    );
    add(effect);
    await effect.removed;
  }

  Future<void> moveOneStep() async {
    if (r + 1 == 10) {
      moveToEnd();
      return;
    }
    r++;
    var pos = gameManager.sizeConfig.getEnemyPos(r, c, body);
    final effect = MoveToEffect(
      pos,
      EffectController(
        duration: 0.3,
        curve: Curves.bounceOut,
      ),
    );
    add(effect);
    await effect.removed;
  }

  Future<void> takeDamage(double damage);

  void moveToEnd() {
    log('entity move to end $r $c');
    gameManager.removeBoardEntity(this, false);
  }

  void dead() {
    gameManager.removeBoardEntity(this, true);
  }
}
