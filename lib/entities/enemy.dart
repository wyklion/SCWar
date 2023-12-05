import 'dart:async';
import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../config/game_config.dart';
import 'entity.dart';

// class ConvexRectanglePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;

//     double width = size.width;
//     double height = size.height;

//     Path path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(width, 0)
//       ..lineTo(width, height - 20)
//       ..quadraticBezierTo(width / 2, height + 20, 0, height - 20)
//       ..close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

class Enemy extends BoardEntity {
  late double target;
  HurtEffect? hurtEffect;
  Enemy(int r, int c, double x, double y, double value, int body)
      : super(r, c, x, y, body, value) {
    target = value;
    final size = Vector2.all(GameConfig.baseLen);
    if (body == 2) {
      size.setAll(GameConfig.doubleBaseLen);
    }
    // var img = Flame.images.fromCache('blue.png');
    // final sprite = Sprite(img);
    // final player =
    //     SpriteComponent(size: size, sprite: sprite, anchor: Anchor.center);
    // add(player);
    // player.priority = -1;
    paint.color = body == 1 ? ColorMap.enemy : ColorMap.enemy2;
  }

  @override
  Future<void> takeDamage(double damage) async {
    if (target <= 0) return;
    target = target - damage;
    if (target < 0) target = 0;
    if (target < 1000) {
      target = target.floorToDouble();
    }
    if (hurtEffect != null) {
      var currentHurtEffect = hurtEffect!;
      currentHurtEffect.startValue = value;
      currentHurtEffect.targetValue = target;
      currentHurtEffect.reset();
      return;
    }
    add(gameManager.particles.createRectExplode());
    add(RotateEffect.by(
      0.2,
      ZigzagEffectController(
        period: 0.1,
      ),
    ));
    hurtEffect = HurtEffect(
      target,
      EffectController(duration: 0.3),
      onComplete: () {
        if (target <= 0) {
          dead();
        }
      },
    );
    add(hurtEffect!);
    await hurtEffect!.removed;
    hurtEffect = null;
  }

  Future<void> beat() async {
    var beatEffect = RotateEffect.by(
      0.2,
      ZigzagEffectController(
        period: 0.1,
      ),
    );
    add(beatEffect);

    var colorEffect = ColorEffect(
      const Color(0xFF000000),
      EffectController(duration: 0.3),
    );
    add(colorEffect);

    await colorEffect.removed;
  }

  @override
  void render(Canvas canvas) {
    // 绘制敌人
    // final paint = Paint()..color = Colors.red;
    var len = body == 1 ? GameConfig.baseLen : GameConfig.doubleBaseLen;
    final roundedRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: len, height: len),
        const Radius.circular(5));
    canvas.drawRRect(roundedRect, paint);
    // canvas.drawRect(
    //     Rect.fromCenter(center: Offset.zero, width: len, height: len), paint);
    // final painter = ConvexRectanglePainter();
    // painter.paint(canvas, Size.square(len));
  }

  @override
  void update(double dt) {
    // 处理敌人的逻辑，比如移动等
  }
}

class HurtEffect extends ComponentEffect<Enemy> {
  double targetValue;
  double startValue = 0;

  HurtEffect(this.targetValue, super.controller, {super.onComplete});

  @override
  void onStart() {
    super.onStart();
    startValue = target.value; // 保存起始数值
  }

  @override
  void apply(double progress) {
    final dProgress = progress - previousProgress;
    var value = target.value - ((startValue - targetValue) * dProgress).toInt();
    target.setValue(value);
  }

  @override
  void onFinish() {
    target.setValue(targetValue);
    super.onFinish();
  }
}
