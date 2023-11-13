import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import 'entity.dart';

class Enemy extends Entity {
  int r;
  int c;
  int body;
  Enemy(this.r, this.c, double x, double y, int value, this.body)
      : super(x, y, false, value);

  // 处理敌人被攻击后的逻辑
  void takeDamage(int damage) {
    var target = value - damage;
    if (target < 0) target = 0;
    add(HurtEffect(target, EffectController(duration: 0.3)));
    if (value <= 0) {
      // 敌人被击败的逻辑
      // 可以在这里添加得分等操作
    }
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
