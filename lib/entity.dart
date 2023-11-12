import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';

abstract class Entity extends PositionComponent {
  int value;
  bool isCircle;

  Entity(double x, double y, this.isCircle, this.value) {
    this.x = x;
    this.y = y;
  }

  void renderBg(Canvas canvas);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderBg(canvas);
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$value',
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
        canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }
}

class Tower extends Entity with TapCallbacks {
  // 炮塔的数值
  Tower(double x, double y, int value) : super(x, y, true, value);

  @override
  void onTapDown(TapDownEvent event) {
    log('click tower');
    y += 100;
  }

  // 炮塔升级
  void upgrade() {
    value *= 2;
    // 更新炮塔外观或其他操作
  }

  @override
  void renderBg(Canvas canvas) {
    // 绘制炮塔
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(x, y), 25, paint);
  }

  @override
  void update(double dt) {
    // 处理炮塔的逻辑
  }
}

class Enemy extends Entity {
  Enemy(double x, double y, int value) : super(x, y, false, value);

  // 处理敌人被攻击后的逻辑
  void takeDamage(int damage) {
    value -= damage;
    if (value <= 0) {
      // 敌人被击败的逻辑
      // 可以在这里添加得分等操作
    }
  }

  @override
  void renderBg(Canvas canvas) {
    // 绘制敌人
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(Rect.fromLTWH(x - 25, y - 25, 50, 50), paint);
  }

  @override
  void update(double dt) {
    // 处理敌人的逻辑，比如移动等
  }
}
