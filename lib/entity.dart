import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'game.dart';
import 'game_config.dart';

abstract class Entity extends PositionComponent {
  int value;
  bool isCircle;
  late TextComponent text;

  Entity(double x, double y, this.isCircle, this.value) {
    size.setAll(GameConfig.baseLen);
    (Color, double) nconfig =
        numberMap[value] ?? (const Color.fromARGB(1, 1, 1, 1), 1);
    this.x = x;
    this.y = y;
    final renderer =
        TextPaint(style: TextStyle(fontSize: 20, color: nconfig.$1));
    text = TextComponent(
        text: '$value',
        anchor: Anchor.center,
        textRenderer: renderer,
        scale: Vector2.all(nconfig.$2),
        size: Vector2.all(GameConfig.baseLen));
    add(text);
  }

  void renderBg(Canvas canvas);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderBg(canvas);
    // final textPainter = TextPainter(
    //   text: TextSpan(
    //     text: '$value',
    //     style: const TextStyle(color: Colors.white, fontSize: 20),
    //   ),
    //   textDirection: TextDirection.ltr,
    // )..layout();
    // textPainter.paint(
    //     canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }
}

enum TowerState {
  ready,
  moving,
  virtual,
  backing,
}

class Tower extends Entity
    with HasGameRef<SCWarGame>, TapCallbacks, DragCallbacks {
  TowerState state = TowerState.ready;
  late final Rect _rect;
  Vector2 movingPos = Vector2(0, 0);
  Vector2 pos = Vector2(0, 0);
  Tower? mergingTower;
  Paint paint = Paint()..color = Colors.blue;
  Tower(double x, double y, int value) : super(x, y, true, value) {
    _rect = Rect.fromCenter(
        center: Offset.zero,
        width: GameConfig.baseLen,
        height: GameConfig.baseLen);
    pos.x = x;
    pos.y = y;
    log(_rect.toString());
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
    super.onDragStart(event);
    state = TowerState.moving;
    movingPos.x = pos.x;
    movingPos.y = pos.y;
    priority = 1;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    movingPos.x += event.delta.x;
    movingPos.y += event.delta.y;
    var tower = gameRef.gameManager.checkTowerByPos(movingPos.x, movingPos.y);
    x = movingPos.x;
    y = movingPos.y;
    if (tower is Tower && tower.value == value) {
      x = tower.pos.x;
      y = tower.pos.y;
      paint.color = Colors.lightBlue;
      mergingTower = tower;
      text.text = '${value * 2}';
    } else {
      text.text = '$value';
      mergingTower = null;
      paint.color = Colors.blue;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (mergingTower != null) {
      mergingTower!.upgrade();
      removeFromParent();
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

class Enemy extends Entity {
  int body;
  Enemy(double x, double y, int value, this.body) : super(x, y, false, value);

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
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero,
            width: GameConfig.baseLen,
            height: GameConfig.baseLen),
        paint);
  }

  @override
  void update(double dt) {
    // 处理敌人的逻辑，比如移动等
  }
}
