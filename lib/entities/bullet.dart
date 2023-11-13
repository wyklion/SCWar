import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';

class Bullet extends PositionComponent {
  int value;
  double dis;
  late Paint paint;
  Bullet(this.value, this.dis)
      : super(position: Vector2(0, -GameConfig.baseLen / 2)) {
    scale.setAll(1 + 0.1 * math.log(value));
    paint = Paint()..color = Colors.red;
  }

  @override
  Future<void> onLoad() async {
    priority = 2;
    var d = dis / GameConfig.baseLen / 10;
    add(SequenceEffect([
      MoveByEffect(Vector2(0, -dis), EffectController(duration: d)),
      RemoveEffect()
    ]));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset.zero, GameConfig.baseLen / 10, paint);
  }

  @override
  void update(double dt) {
    // 处理敌人的逻辑，比如移动等
  }
}
