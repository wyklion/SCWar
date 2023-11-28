import 'dart:developer';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import 'entity.dart';

class Energy extends BoardEntity {
  Energy(int r, int c, double x, double y, int value)
      : super(r, c, x, y, 1, value);

  @override
  Future<void> takeDamage(int damage) async {
    // log('energy takeDamage $damage');
    var targetPos = gameManager.prepareTowerPos;
    gameManager.addPreMerge(value);
    var moveEffect = MoveToEffect(targetPos, EffectController(duration: 0.3),
        onComplete: () {
      dead();
    });
    add(moveEffect);
    await moveEffect.removed;
  }

  @override
  void renderBg(Canvas canvas) {
    // 绘制敌人
    // final paint = Paint()..color = Colors.green;
    canvas.drawCircle(Offset.zero, GameConfig.baseLen / 3, paintMap['energy']!);
  }
}
