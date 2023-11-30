import 'dart:async';
import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import 'entity.dart';

class Enemy extends BoardEntity {
  late int target;
  HurtEffect? hurtEffect;
  Paint paint = Paint();
  Enemy(int r, int c, double x, double y, int value, int body)
      : super(r, c, x, y, body, value) {
    target = value;
    final size = Vector2.all(GameConfig.baseLen);
    if (body == 2) {
      size.setAll(GameConfig.doubleBaseLen);
    }
    // var img = Flame.images.fromCache('blue.png');
    // final sprite = Sprite(img);
    // final player =
    //     SpriteComponent(size: size, sprite: sprite, anchor: Anchor.center);
    // add(player);
    // player.priority = -1;
    paint.color = body == 1 ? ColorMap.enemy : ColorMap.enemy2;
  }

  @override
  Future<void> takeDamage(int damage) async {
    if (target == 0) return;
    target = target - damage;
    if (target < 0) target = 0;
    if (hurtEffect != null) {
      var currentHurtEffect = hurtEffect!;
      currentHurtEffect.startValue = value;
      currentHurtEffect.targetValue = target;
      currentHurtEffect.reset();
      return;
    }
    hurtEffect = HurtEffect(
      target,
      EffectController(duration: 0.3),
      onComplete: () {
        if (target == 0) {
          dead();
        }
      },
    );
    add(hurtEffect!);
    await hurtEffect!.removed;
    hurtEffect = null;
  }

  @override
  void moveToEnd() {
    log('enemy move to die $r $c');
    gameManager.dead();
  }

  @override
  void renderBg(Canvas canvas) {
    // 绘制敌人
    // final paint = Paint()..color = Colors.red;
    var len = body == 1 ? GameConfig.baseLen : GameConfig.doubleBaseLen;
    canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: len, height: len), paint);
  }

  @override
  void update(double dt) {
    // 处理敌人的逻辑，比如移动等
  }
}

class HurtEffect extends ComponentEffect<Enemy> {
  int targetValue;
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
