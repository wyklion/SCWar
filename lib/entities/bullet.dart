import 'dart:developer';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:scwar/entities/enemy.dart';
import 'package:scwar/entities/entity.dart';
import 'package:scwar/game.dart';
import '../game_config.dart';

class Bullet extends CircleComponent with HasGameRef<SCWarGame> {
  int value;
  int r;
  int c;
  // double dis;
  int hittedRow = 10;
  // late Paint paint;
  List<Future<void>> tasks = [];
  Bullet(this.value, this.r, this.c /*,this.dis*/)
      : super(radius: GameConfig.baseLen / 10, anchor: Anchor.center) {
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
    moveNext();
    // List<BoardEntity> list = gameManager.getColEnemys(c);
    // List<Effect> effects = [];
    // var remain = value;
    // double y = position.y;
    // for (var i = 0; i < list.length; i++) {
    //   var entity = list[i];
    //   var enemyR = entity.r;
    //   if (entity.body == 2) {
    //     enemyR += 1;
    //   }
    //   var nextPos = gameManager.sizeConfig.getEnemyPos(enemyR, c, 1);
    //   var nextY = nextPos.y + GameConfig.baseLen / 2;
    //   var d = (y - nextY) / GameConfig.baseLen / 10;
    //   y = nextY;
    //   // log('list $i, ${list[i].r}, ${list[i].value}');
    //   effects.add(MoveToEffect(
    //     Vector2(nextPos.x, nextY),
    //     EffectController(
    //         duration: d,
    //         onMax: makeAttackCallback(list[i].r, list[i].c, remain)),
    //   ));
    //   if (entity is Enemy) {
    //     remain -= entity.target;
    //   }
    //   if (remain <= 0) {
    //     break;
    //   }
    // }
    // if (remain > 0) {
    //   var nextPos = gameManager.sizeConfig.getEnemyPos(-1, c, 1);
    //   var nextY = nextPos.y + GameConfig.baseLen;
    //   var d = (y - nextY) / GameConfig.baseLen / 10;
    //   effects.add(MoveToEffect(
    //     Vector2(nextPos.x, nextY),
    //     EffectController(duration: d),
    //   ));
    // }
    // effects.add(RemoveEffect());
    // add(SequenceEffect(effects));
    return super.onLoad();
  }

  void moveNext() {
    var gameManager = gameRef.gameManager;
    List<BoardEntity> list = gameManager.getColEnemys(c);
    double y = position.y;
    for (var i = 0; i < list.length; i++) {
      var entity = list[i];
      var enemyR = entity.r;
      if (enemyR >= hittedRow) {
        continue;
      }
      hittedRow = enemyR;
      if (entity.body == 2) {
        enemyR += 1;
      }
      var nextPos = gameManager.sizeConfig.getEnemyPos(enemyR, c, 1);
      var nextY = nextPos.y + GameConfig.baseLen / 2;
      var d = (y - nextY) / GameConfig.baseLen / 10;
      y = nextY;
      // log('list $i, ${list[i].r}, ${list[i].value}');
      add(MoveToEffect(
        Vector2(nextPos.x, nextY),
        EffectController(
            duration: d,
            onMax: makeAttackCallback(list[i].r, list[i].c, value)),
      ));
      return;
    }
    var nextX = gameManager.sizeConfig.getBoardX(c);
    var nextY = gameManager.sizeConfig.getTopY();
    var d = (y - nextY) / GameConfig.baseLen / 10;
    add(SequenceEffect([
      MoveToEffect(
        Vector2(nextX, nextY),
        EffectController(duration: d),
      ),
      RemoveEffect(),
    ]));
  }

  VoidCallback makeAttackCallback(int r, int c, int value) {
    return () {
      var entity = gameRef.gameManager.board[r][c];
      if (entity is Enemy) {
        this.value -= entity.target;
      }
      gameRef.gameManager.attackEnemy(r, c, value);
      if (this.value <= 0) {
        removeFromParent();
      } else {
        moveNext();
      }
    };
  }

  // @override
  // void render(Canvas canvas) {
  //   canvas.drawCircle(Offset.zero, GameConfig.baseLen / 10, paint);
  // }

  // @override
  // void update(double dt) {
  //   // 处理敌人的逻辑，比如移动等
  // }
}
