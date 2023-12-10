import 'package:scwar/config/config.dart';
import 'package:scwar/data/game_data.dart';
import 'package:scwar/data/local_storage.dart';

class PlayerData {
  String version = Config.version;
  int gameTimes = 0;
  double highScore = 0;
  double bigestTower = 0;
  int playerMoveCount = 0;
  int enemyCount = 0;
  int energyCount = 0;
  int energyMultiplyCount = 0;
  int tutorial = 0;
  // 50关卡数据[[胜次，败次]]
  List<List<int>> levels = List.generate(51, (_) => [0, 0]);

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

  saveStorage(LocalStorage storage) {
    dynamic json = {};
    json['version'] = version;
    json['gameTimes'] = gameTimes;
    json['highScore'] = highScore;
    json['bigestTower'] = bigestTower;
    json['playerMoveCount'] = playerMoveCount;
    json['enemyCount'] = enemyCount;
    json['energyCount'] = energyCount;
    json['energyMultiplyCount'] = energyMultiplyCount;
    json['tutorial'] = tutorial;
    storage.setPlayerJson(json);
  }

  saveLevelsStorage(LocalStorage storage) {
    storage.setLevelsJson(levels);
  }

  void loadFromStorage(LocalStorage storage) {
    dynamic json = storage.getPlayerJson();
    if (json != null) {
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
      tutorial = json['tutorial'] ?? 0;
    }
    var ljson = storage.getLevelsJson();
    if (ljson != null) {
      for (var i = 0; i < ljson.length; i++) {
        levels[i][0] = ljson[i][0];
        levels[i][1] = ljson[i][1];
      }
    }
  }

  isLevelPassed(int level) {
    return levels[level][0] > 0;
  }

  updateVersion() {
    version = Config.version;
    // 本地数据可能要更新版本。
  }
}
