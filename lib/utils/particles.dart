import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:scwar/game_config.dart';

class RectComponent extends Component {
  @override
  void render(Canvas c) {
    c.drawRect(Rect.fromCenter(center: Offset.zero, width: 10, height: 10),
        Paint()..color = Colors.lightBlue);
  }

  @override
  void update(double dt) {}
}

class Particles {
  late Particle enemyHurt;
  static final Random _random = Random();
  Vector2 randomVector2() =>
      (Vector2.random(_random) - Vector2.random(_random)) * 500;

  // 私有构造函数，防止类被实例化
  Particles._() {
    enemyHurt = Particle.generate(
      count: 10,
      generator: (i) => AcceleratedParticle(
        speed: randomVector2(),
        acceleration: Vector2(0, 98),
        lifespan: 0.2,
        child: CircleParticle(
          paint: Paint()..color = Colors.lightBlue,
        ),
      ),
    );
  }
  // 单例实例
  static final Particles _instance = Particles._();
  // 工厂构造函数，用于返回单例实例
  factory Particles() {
    return _instance;
  }

  ParticleSystemComponent createRectExplode() {
    Particle rectExplode = Particle.generate(
      count: 15,
      lifespan: 0.3,
      generator: (i) => AcceleratedParticle(
        speed: randomVector2(),
        acceleration: Vector2(0, 200),
        child: RotatingParticle(
          to: (_random.nextDouble() - 0.5) * pi * 2,
          child: ComputedParticle(
            renderer: (canvas, particle) => canvas.drawRect(
              Rect.fromCenter(center: Offset.zero, width: 10, height: 10),
              Paint()
                ..color = ColorMap.bullet.withOpacity(1 - particle.progress),
            ),
          ),
        ),
      ),
    );
    return ParticleSystemComponent(particle: rectExplode);
  }
}
