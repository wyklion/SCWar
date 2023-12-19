import 'package:flame/components.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/utils/number_util.dart';

class HomeComponent extends Component with HasGameRef<SCWarGame> {
  late TextComponent gameTimes;
  late TextComponent bigestTower;
  late TextComponent playerMoveCount;
  late TextComponent enemyCount;
  HomeComponent();

  @override
  Future<void> onLoad() async {
    if (Config.testMode) {
      gameTimes = addData('GameTimes', '${game.playerData.gameTimes}', 1);
      bigestTower = addData('BigestTower',
          ' ${NumberUtil.getTowerString(game.playerData.bigestTower)}', 2);
      playerMoveCount =
          addData('ShootTimes', ' ${game.playerData.playerMoveCount}', 3);
      enemyCount = addData('KillEnemies', ' ${game.playerData.enemyCount}', 4);
    }
    return super.onLoad();
  }

  void changeTestMode() {
    if (!Config.testMode) {
      removeAll(children);
    } else {
      onLoad();
    }
  }

  TextComponent addData(String label, String value, int idx) {
    add(TextComponent(
      anchor: Anchor.centerRight,
      text: label,
      textRenderer: TextPaint(style: TextStyleMap.dataLabel),
      position: Vector2(20, 240 + idx * 30),
    ));
    var text = TextComponent(
      anchor: Anchor.centerLeft,
      text: value,
      textRenderer: TextPaint(style: TextStyleMap.data),
      position: Vector2(30, 240 + idx * 30),
    );
    add(text);
    return text;
  }
}
