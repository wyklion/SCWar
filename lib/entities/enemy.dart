import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import 'entity.dart';

class Enemy extends BoardEntity {
  int body;
  Enemy(int r, int c, double x, double y, int value, this.body)
      : super(r, c, x, y, value) {
    var img = Flame.images.fromCache('blue.png');
    final sprite = Sprite(img);
    final size = Vector2.all(GameConfig.baseLen);
    final player =
        SpriteComponent(size: size, sprite: sprite, anchor: Anchor.center);
    add(player);
    player.priority = -1;
  }

  @override
  Future<void> takeDamage(int damage) async {
    var target = value - damage;
    if (target < 0) target = 0;
    var hurtEffect =
        HurtEffect(target, EffectController(duration: 0.3), onComplete: () {
      if (target == 0) {
        dead();
      }
    });
    add(hurtEffect);
    await hurtEffect.removed;
  }

  @override
  void renderBg(Canvas canvas) {
    // 绘制敌人
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero,
            width: GameConfig.baseLen,
            height: GameConfig.baseLen),
        paint);
  }

  @override
  void update(double dt) {
    // 处理敌人的逻辑，比如移动等
  }
}

class HurtEffect extends ComponentEffect<Enemy> {
  final int targetValue;
  int startValue = 0;

  HurtEffect(this.targetValue, super.controller, {super.onComplete});

  @override
  void onStart() {
    super.onStart();
    startValue = target.value; // 保存起始数值
  }

  @override
  void apply(double progress) {
    final dProgress = progress - previousProgress;
    target.value -= ((startValue - targetValue) * dProgress).toInt();
    target.text.text = '${target.value}';
  }

  @override
  void onFinish() {
    target.value = targetValue;
    target.text.text = '$targetValue';
    super.onFinish();
  }
}
