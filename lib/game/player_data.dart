import 'package:scwar/config/config.dart';
import 'package:scwar/game/game_data.dart';

class PlayerData {
  String version = Config.version;
  int gameTimes = 0;
  double highScore = 0;
  double bigestTower = 0;
  int playerMoveCount = 0;
  int enemyCount = 0;
  int energyCount = 0;
  int energyMultiplyCount = 0;

  void updateGameData(GameData data) {
    gameTimes++;
    playerMoveCount += data.playerMoveCount;
    enemyCount += data.playerMoveCount;
    energyCount += data.energyCount;
    energyMultiplyCount += data.energyMultiplyCount;
    if (data.score > highScore) {
      highScore = data.score;
    }
    if (data.bigTower > bigestTower) {
      bigestTower = data.bigTower;
    }
  }

  dynamic saveJson() {
    dynamic json = {};
    json['version'] = version;
    json['gameTimes'] = gameTimes;
    json['highScore'] = highScore;
    json['bigestTower'] = bigestTower;
    json['playerMoveCount'] = playerMoveCount;
    json['enemyCount'] = enemyCount;
    json['energyCount'] = energyCount;
    json['energyMultiplyCount'] = energyMultiplyCount;
    return json;
  }

  void loadJson(dynamic json) {
    if (json == null) {
      return;
    }
    version = json['version'];
    if (version != Config.version) {
      updateVersion();
    }
    gameTimes = json['gameTimes'] ?? 0;
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
