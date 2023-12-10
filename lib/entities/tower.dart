import 'dart:async';
import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'package:scwar/entities/idle_state.dart';
import 'package:scwar/game/game_manager.dart';
import 'package:scwar/utils/number_util.dart';
import '../config/game_config.dart';
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
  late IdleState _idleState;
  Tower(this.r, this.c, super.x, super.y, super.value) {
    paint.color = ColorMap.tower;
    _rect = Rect.fromCenter(
        center: Offset.zero,
        width: GameConfig.baseLen,
        height: GameConfig.baseLen);
    pos.x = x;
    pos.y = y;
    // log(_rect.toString());
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    _idleState = IdleState(gameManager, idleTime: 0.5, maxDelay: 5);
  }

  @override
  String getDisplay({double? value}) {
    var v = value ?? this.value;
    return NumberUtil.getTowerString(v);
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

  // @override
  // void onTapDown(TapDownEvent event) {
  //   log('onTapDown');
  // }

  // @override
  // void onTapUp(TapUpEvent event) {
  //   log('onTapUp');
  // }

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
    paint.color = ColorMap.towerMove;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (state != TowerState.moving) {
      return;
    }
    final deltaX = event.localDelta.x;
    final deltaY = event.localDelta.y;

    movingPos.x += deltaX;
    movingPos.y += deltaY;
    var (tower, towerBlockPos) =
        gameManager.checkTowerByPos(movingPos.x, movingPos.y);
    x = movingPos.x;
    y = movingPos.y;
    if (tower != this && tower is Tower) {
      movePos = null;
      x = tower.pos.x;
      y = tower.pos.y;
      if (NumberUtil.nearlyEqual(tower.value, value)) {
        if (mergingTower != tower) {
          gameManager.soundManager.playSnap();
        }
        paint.color = ColorMap.towerMerge;
        mergingTower = tower;
        swapTower = null;
        setTextValue(value * 2);
        // log('on merge $value->${tower.value}');
      } else {
        if (swapTower != tower) {
          gameManager.soundManager.playSnap();
        }
        setTextValue(value);
        paint.color = ColorMap.towerSwap;
        swapTower = tower;
        mergingTower = null;
        // log('on swap $value->${tower.value}');
      }
    } else {
      text.text = getDisplay();
      mergingTower = null;
      swapTower = null;
      paint.color = ColorMap.towerMove;
      if (towerBlockPos != null) {
        if (movePos != towerBlockPos) {
          gameManager.soundManager.playSnap();
        }
        var (tr, tc) = towerBlockPos;
        var tp = gameManager.sizeConfig.getTowerPos(tr, tc);
        x = tp.x;
        y = tp.y;
        movePos = towerBlockPos;
      } else {
        movePos = null;
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
    // 还原颜色
    paint.color = ColorMap.tower;
    priority = 0;
    if (mergingTower != null) {
      gameManager.mergeTower(mergingTower!, this);
    } else if (swapTower != null) {
      gameManager.swapTower(this, swapTower!);
    } else if (movePos != null && movePos != (r, c)) {
      gameManager.moveTower(this, movePos!.$1, movePos!.$2);
    } else {
      goBack();
    }
  }

  void goBack() {
    state = TowerState.backing;
    mergingTower = null;
    paint.color = ColorMap.tower;
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
      value /= 2;
    }
    // 更新炮塔外观或其他操作
    setTextValue(value);
    var upgradeEffect = SequenceEffect([
      ColorEffect(
        const Color(0xFF7f16ff),
        EffectController(duration: 0.1),
      ),
      ColorEffect(
        ColorMap.tower,
        EffectController(duration: 0.1),
      ),
    ], repeatCount: 2);
    add(upgradeEffect);
  }

  Future<void> shoot() async {
    add(
      ScaleEffect.to(
        Vector2.all(1.2),
        SequenceEffectController([
          LinearEffectController(0.1),
          ReverseLinearEffectController(0.1),
        ]),
      ),
    );
    var bullet = Bullet(value, r, c);
    game.addContent(bullet);
    await bullet.removed;
    // log('tower $r,$c bullet removed');
  }

  @override
  void render(Canvas canvas) {
    // 绘制炮塔
    var radius = GameConfig.baseLen / 2;
    // canvas.drawCircle(Offset.zero, radius, paint);

    // // 绘制底部阴影
    // final shadowPaint = Paint()
    //   ..color = Colors.black.withOpacity(0.3)
    //   ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    // canvas.drawCircle(Offset.zero, radius, shadowPaint);

    // // 绘制主体圆形
    // final gradient = RadialGradient(
    //   center: Alignment.center,
    //   radius: 0.5,
    //   colors: [paint.color, const Color(0xFF2ECC71)],
    //   stops: const [0.0, 1.0],
    // );
    // final circlePaint = Paint()
    //   ..shader = gradient
    //       .createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
    // canvas.drawCircle(Offset.zero, radius, circlePaint);
    double scale = 1 + _idleState.value * 0.1;
    canvas.drawCircle(Offset.zero, radius * scale, paint);
  }

  @override
  void update(double dt) {
    // 处理炮塔的逻辑
    _idleState.update(dt);
  }
}
