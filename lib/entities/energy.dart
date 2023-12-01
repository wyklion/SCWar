import 'dart:developer';
import 'dart:js_util';
import 'package:flame/effects.dart';
import 'package:flutter/rendering.dart';
import 'package:scwar/utils/unit_util.dart';
import '../game_config.dart';
import 'entity.dart';

class Energy extends BoardEntity {
  Energy(int r, int c, double x, double y, int value, EntityType type)
      : super(r, c, x, y, 1, value) {
    this.type = type;
  }

  @override
  String getDisplay({int? value}) {
    var v = this.value;
    if (type == EntityType.energyMultiply) {
      return 'x$v';
    }
    return UnitUtil.convertValue(v, 0);
  }

  @override
  Future<void> takeDamage(int damage) async {
    // log('energy takeDamage $damage');
    if (type == EntityType.energy) {
      var targetPos = gameManager.prepareTowerPos;
      gameManager.addPreMerge(value);
      var moveEffect = MoveToEffect(targetPos, EffectController(duration: 0.3),
          onComplete: () {
        dead();
      });
      this.add(moveEffect);
      await moveEffect.removed;
    } else if (type == EntityType.energyMultiply) {
      var l = gameManager.towers.length;
      var randomTower = gameManager.towers[gameManager.random.nextInt(l)];
      var moveEffect = MoveToEffect(
        randomTower.position,
        EffectController(duration: 0.3),
        onComplete: () {
          gameManager.doubleTower(randomTower);
          dead();
        },
      );
      this.add(moveEffect);
      await moveEffect.removed;
    }
  }

  @override
  void renderBg(Canvas canvas) {
    // 绘制敌人
    // final paint = Paint()..color = Colors.green;
    var paint = type == EntityType.energy
        ? paintMap['energy']!
        : paintMap['energyMultiply']!;
    canvas.drawCircle(Offset.zero, GameConfig.baseLen / 3, paint);
  }
}
