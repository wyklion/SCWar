import 'package:scwar/config/config.dart';
import 'package:scwar/game/game_data.dart';

class PlayerData {
  String version = Config.version;
  int gameTime = 0;
  double highScore = 0;
  int bigestTower = 0;
  int playerMoveCount = 0;
  int enemyCount = 0;
  int energyCount = 0;
  int energyMultiplyCount = 0;

  void updateGameData(GameData data) {}

  dynamic saveJson() {
    dynamic json = {};
    json['version'] = version;
    json['gameTime'] = gameTime;
    json['highScore'] = highScore;
    json['bigestTower'] = bigestTower;
    json['playerMoveCount'] = playerMoveCount;
    json['enemyCount'] = enemyCount;
    json['energyCount'] = energyCount;
    json['energyMultiplyCount'] = energyMultiplyCount;
  }

  void loadJson(dynamic json) {
    if (json == null) {
      return;
    }
    version = json['energyCount'];
    if (version != Config.version) {
      updateVersion();
    }
    gameTime = json['gameTime'] ?? 0;
    highScore = json['highScore'] ?? 0;
    bigestTower = json['bigestTower'] ?? 0;
    playerMoveCount = json['playerMoveCount'] ?? 0;
    enemyCount = json['enemyCount'] ?? 0;
    energyCount = json['energyCount'] ?? 0;
    energyMultiplyCount = json['energyMultiplyCount'] ?? 0;
  }

  updateVersion() {
    version = Config.version;
    // 本地数据可能要更新版本。
  }
}
