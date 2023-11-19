import 'dart:developer';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:scwar/entities/enemy.dart';
import 'package:scwar/entities/entity.dart';
import 'package:scwar/game.dart';
import '../game_config.dart';

class Bullet extends PositionComponent with HasGameRef<SCWarGame> {
  int value;
  int r;
  int c;
  // double dis;
  late Paint paint;
  List<Future<void>> tasks = [];
  Bullet(this.value, this.r, this.c /*,this.dis*/) {
    scale.setAll(1 + 0.1 * math.log(value));
    paint = Paint()..color = Colors.red;
    priority = 2;
  }

  @override
  Future<void> onLoad() async {
    var gameManager = gameRef.gameManager;
    var pos = gameManager.sizeConfig.getTowerPos(r, c);
    position.x = pos.x;
    position.y = pos.y - GameConfig.baseLen / 2;
    List<BoardEntity> list = gameManager.getColEnemys(c);
    List<Effect> effects = [];
    var remain = value;
    double y = position.y;
    for (var i = 0; i < list.length; i++) {
      var nextPos = gameManager.sizeConfig.getEnemyPos(list[i].r, c);
      var nextY = nextPos.y + GameConfig.baseLen / 2;
      var d = (y - nextY) / GameConfig.baseLen / 10;
      y = nextY;
      log('list $i, ${list[i].r}, ${list[i].value}');
      effects.add(MoveToEffect(
        Vector2(nextPos.x, nextY),
        EffectController(
            duration: d, onMax: makeAttackCallback(list[i].r, c, remain)),
      ));
      if (list[i] is Enemy) {
        remain -= list[i].value;
      }
      if (remain <= 0) {
        break;
      }
    }
    if (remain > 0) {
      var nextPos = gameManager.sizeConfig.getEnemyPos(-1, c);
      var nextY = nextPos.y + GameConfig.baseLen;
      var d = (y - nextY) / GameConfig.baseLen / 10;
      effects.add(MoveToEffect(
        Vector2(nextPos.x, nextY),
        EffectController(duration: d),
      ));
    }
    effects.add(RemoveEffect());
    add(SequenceEffect(effects));
    return super.onLoad();
  }

  VoidCallback makeAttackCallback(int r, int c, int value) {
    return () => gameRef.gameManager.attackEnemy(r, c, value);
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
