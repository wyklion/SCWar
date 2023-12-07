import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/utils/number_util.dart';

class HomeComponent extends Component with HasGameRef<SCWarGame> {
  late TextComponent gameTimes;
  late TextComponent bigestTower;
  late TextComponent playerMoveCount;
  late TextComponent enemyCount;
  final dataLabelStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6D7993));
  final dataStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFD3E2F2));
  HomeComponent();

  @override
  Future<void> onLoad() async {
    gameTimes = addData('GameTimes', '${game.playerData.gameTimes}', 1);
    bigestTower = addData('BigestTower',
        ' ${NumberUtil.getTowerString(game.playerData.bigestTower)}', 2);
    playerMoveCount =
        addData('ShootTimes', ' ${game.playerData.playerMoveCount}', 3);
    enemyCount = addData('KillEnymies', ' ${game.playerData.enemyCount}', 4);
    return super.onLoad();
  }

  TextComponent addData(String label, String value, int idx) {
    add(TextComponent(
      anchor: Anchor.centerRight,
      text: label,
      textRenderer: TextPaint(style: dataLabelStyle),
      position: Vector2(20, 230 + idx * 30),
    ));
    var text = TextComponent(
      anchor: Anchor.centerLeft,
      text: value,
      textRenderer: TextPaint(style: dataStyle),
      position: Vector2(30, 230 + idx * 30),
    );
    add(text);
    return text;
  }
}
