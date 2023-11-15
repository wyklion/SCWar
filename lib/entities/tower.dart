import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'package:scwar/game_manager.dart';
import '../game_config.dart';
import 'bullet.dart';
import 'entity.dart';

enum TowerState {
  ready,
  moving,
  virtual,
  backing,
}

class Tower extends Entity with TapCallbacks, DragCallbacks {
  int r;
  int c;
  TowerState state = TowerState.ready;
  late final Rect _rect;
  Vector2 movingPos = Vector2(0, 0);
  Vector2 pos = Vector2(0, 0);
  Tower? mergingTower;
  Tower? swapTower;
  (int, int)? movePos;
  Paint paint = Paint()..color = Colors.blue;
  Tower(this.r, this.c, double x, double y, int value) : super(x, y, value) {
    _rect = Rect.fromCenter(
        center: Offset.zero,
        width: GameConfig.baseLen,
        height: GameConfig.baseLen);
    pos.x = x;
    pos.y = y;
    log(_rect.toString());
  }

  void setPos(int r, int c) {
    this.r = r;
    this.c = c;
    var towerPos = gameManager.sizeConfig.getTowerPos(r, c);
    pos.x = x = towerPos.x;
    pos.y = y = towerPos.y;
  }

  @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());

  @override
  void onTapDown(TapDownEvent event) {
    log('onTapDown');
  }

  @override
  void onTapUp(TapUpEvent event) {
    log('onTapUp');
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (gameManager.currentState != GameState.playerMove) {
      return;
    }
    super.onDragStart(event);
    state = TowerState.moving;
    movingPos.x = pos.x;
    movingPos.y = pos.y;
    priority = 1;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (state != TowerState.moving) {
      return;
    }
    movingPos.x += event.delta.x;
    movingPos.y += event.delta.y;
    var (tower, towerBlockPos) =
        gameManager.checkTowerByPos(movingPos.x, movingPos.y);
    x = movingPos.x;
    y = movingPos.y;
    mergingTower = null;
    swapTower = null;
    movePos = null;
    if (tower != this && tower is Tower) {
      x = tower.pos.x;
      y = tower.pos.y;
      if (tower.value == value) {
        paint.color = Colors.lightBlue;
        mergingTower = tower;
        text.text = '${value * 2}';
      } else {
        paint.color = Colors.blueGrey;
        swapTower = tower;
      }
    } else {
      text.text = '$value';
      mergingTower = null;
      paint.color = Colors.blue;
      if (towerBlockPos != null) {
        var (tr, tc) = towerBlockPos;
        var tp = gameManager.sizeConfig.getTowerPos(tr, tc);
        x = tp.x;
        y = tp.y;
        movePos = towerBlockPos;
      }
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (state != TowerState.moving) {
      return;
    }
    state = TowerState.ready;
    super.onDragEnd(event);
    if (mergingTower != null) {
      gameManager.upgradeTower(mergingTower!);
      gameManager.removeTower(this);
    } else if (swapTower != null) {
      // 还原颜色
      paint.color = Colors.blue;
      gameManager.swapTower(this, swapTower!);
    } else if (movePos != null) {
      gameManager.moveTower(this, movePos!.$1, movePos!.$2);
    } else {
      goBack();
    }
  }

  void goBack() {
    state = TowerState.backing;
    mergingTower = null;
    paint.color = Colors.blue;
    final effect = MoveToEffect(
      pos,
      EffectController(
          duration: 0.3,
          curve: Curves.ease,
          onMax: () {
            state = TowerState.ready;
          }),
    );
    add(effect);
    priority = 0;
  }

  // 炮塔升级
  void upgrade([bool down = false]) {
    if (!down) {
      value *= 2;
    } else {
      value ~/= 2;
    }
    // 更新炮塔外观或其他操作
    text.text = '$value';
  }

  Future<void> shoot(int enemyRow, double dis) async {
    var bullet = Bullet(value, dis);
    add(bullet);
    await bullet.removed;
    // log('tower $r,$c bullet removed');
    if (enemyRow != -1) {
      await gameManager.attackEnemy(enemyRow, c, value);
    }
    // log('tower $r,$c attack finished');
  }

  @override
  void renderBg(Canvas canvas) {
    // 绘制炮塔
    canvas.drawCircle(Offset.zero, GameConfig.baseLen / 2, paint);
  }

  @override
  void update(double dt) {
    // 处理炮塔的逻辑
    if (state == TowerState.backing) {}
  }
}
