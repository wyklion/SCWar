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
  static final TextPaint renderer =
      TextPaint(style: const TextStyle(fontSize: 20, color: Colors.white));
  late TextComponent text;
  bool isValid = true;
  late EntityType type;
  late GameManager gameManager;

  Entity(double x, double y, this.score, {this.type = EntityType.enemy})
      : value = score {
    size.setAll(GameConfig.baseLen);
    this.x = x;
    this.y = y;
  }

  @override
  FutureOr<void> onLoad() {
    text = TextComponent(
        text: getDisplay(),
        anchor: Anchor.center,
        textRenderer: renderer,
        scale: Vector2.all(textScale),
        size: Vector2.all(GameConfig.baseLen));
    add(text);
    gameManager = gameRef.gameManager;
    return super.onLoad();
  }

  double get textScale => 1;

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
  BoardEntity(this.r, this.c, super.x, super.y, super.value,
      {this.body = 1, super.type}) {
    if (body == 2) {
      size.setAll(GameConfig.doubleBaseLen);
    }
  }

  @override
  double get textScale => body == 2 ? 1.2 : 1;

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
