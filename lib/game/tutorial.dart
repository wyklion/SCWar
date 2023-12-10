import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/entities/enemy.dart';
import 'package:scwar/entities/energy.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/game/game_manager.dart';

class TutorialComponent extends Component with HasGameRef<SCWarGame> {}

class TutorialComponent0 extends TutorialComponent {
  GameManager gameManager;
  late Vector2 towerPos;
  TutorialComponent0(this.gameManager) {
    var board = gameManager.board;
    int c = -1;
    int e = 0;
    for (var i = 0; i < board[0].length; i++) {
      if (board[0][i] is Enemy) {
        c = i;
        break;
      } else if (board[0][i] is Energy) {
        e = i;
      }
    }
    if (c == -1) {
      c = e;
    }
    towerPos = gameManager.sizeConfig.getTowerPos(1, c);
  }

  @override
  Future<void> onLoad() async {
    var text = PositionComponent(position: Vector2(40, 240));
    add(text);
    text.add(RectangleComponent(
      size: Vector2(350, 40),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF216583),
    ));
    text.add(
      TextComponent(
        text: "Drag the circle to battlefield",
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFFf9f5ce)),
        ),
      ),
    );
    // 炮塔位置向下箭头
    text.add(PolygonComponent(
      makeArrowPolygon(25, 18),
      anchor: Anchor.center,
      angle: pi,
      position:
          Vector2(towerPos.x - 40, towerPos.y - 225 - GameConfig.baseBlockLen),
      paint: Paint()..color = const Color(0xFF398ab9),
    )..add(MoveEffect.by(
        Vector2(0, 10),
        InfiniteEffectController(ZigzagEffectController(
          period: 1,
        )),
      )));
    text.add(PolygonComponent(
      makeArrowPolygon(25, 30),
      anchor: Anchor.center,
      angle: 2.6,
      position: Vector2(120, 70),
      paint: Paint()..color = const Color(0xFF398ab9),
    )..add(MoveEffect.by(
        Vector2(7, 10),
        InfiniteEffectController(ZigzagEffectController(
          period: 1,
        )),
      )));
  }

  List<Vector2> makeArrowPolygon(double w, double h) {
    return [
      Vector2(-w * 0.3, h),
      Vector2(w * 0.3, h),
      Vector2(w * 0.3, 0),
      Vector2(w, 0),
      Vector2(0, -h),
      Vector2(-w, 0),
      Vector2(-w * 0.3, 0),
    ];
  }
}
