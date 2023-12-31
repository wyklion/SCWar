import 'package:flame/effects.dart';
import 'package:flutter/rendering.dart';
import 'package:scwar/utils/number_util.dart';
import '../config/game_config.dart';
import 'entity.dart';

class Energy extends BoardEntity {
  Energy(super.r, super.c, super.x, super.y, super.value, {super.type});

  @override
  String getDisplay({double? value}) {
    var v = this.value;
    if (type == EntityType.energyMultiply) {
      return 'x${v.toInt()}';
    }
    return NumberUtil.convertValue(v, 0);
  }

  @override
  Future<void> takeDamage(double damage) async {
    // log('energy takeDamage $damage');
    // 不能二次受击
    if (!isValid) {
      return;
    }
    isValid = false;
    if (type == EntityType.energy) {
      var targetPos = gameManager.prepareTowerPos;
      var moveEffect = MoveToEffect(
        targetPos,
        EffectController(duration: 0.3),
        onComplete: () {
          gameManager.onEnergyArrived(this);
          dead();
        },
      );
      add(moveEffect);
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
      add(moveEffect);
      await moveEffect.removed;
    }
  }

  @override
  void render(Canvas canvas) {
    // 绘制敌人
    var paint = type == EntityType.energy
        ? paintMap['energy']!
        : paintMap['energyMultiply']!;
    canvas.drawCircle(Offset.zero, GameConfig.baseLen / 3, paint);
  }
}
