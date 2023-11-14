import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../game.dart';
import '../game_config.dart';
import 'entity.dart';

class Enemy extends Entity with HasGameRef<SCWarGame> {
  int r;
  int c;
  int body;
  Enemy(this.r, this.c, double x, double y, int value, this.body)
      : super(x, y, false, value);

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

  Future<bool> moveOneStep() async {
    if (r + 1 == 10) {
      log('enemy move to die $r $c');
      gameRef.gameManager.removeEnemy(this);
      return false;
    }
    r++;
    var pos = gameRef.gameManager.sizeConfig.getEnemyPos(r, c);
    y = pos.y;
    return true;
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

  void dead() {
    gameRef.gameManager.removeEnemy(this);
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
