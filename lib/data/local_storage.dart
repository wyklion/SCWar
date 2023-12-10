import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  int highScore = 0;
  int playTimes = 0;

  // 单例实例
  static LocalStorage? _instance;
  late SharedPreferences _prefs;

  // 私有构造函数，确保单例
  LocalStorage._internal();

  // 获取单例实例
  static Future<LocalStorage> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorage._internal();
      await _instance!._init();
    }
    return _instance!;
  }

  // 初始化SharedPreferences
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 保存字符串
  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  // 读取字符串
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // 保存布尔值
  Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  // 读取布尔值
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // 保存整数
  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  // 读取整数
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // 保存浮点数
  Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  // 读取浮点数
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // 清除所有数据
  Future<bool> clear() {
    return _prefs.clear();
  }

  // 清除所有数据
  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  ///-------下面是游戏内常用方法-----------
  bool? getSoundOn() {
    return getBool('sound');
  }

  Future<bool> setSoundOn(bool on) {
    return setBool('sound', on);
  }

  // 清除游戏
  Future<bool> removeGame() {
    return remove('latestGame');
  }

  // 是否有未结束游戏
  bool hasGame() {
    var gameStr = getString('latestGame');
    return gameStr != null;
  }

  // 读游戏
  dynamic getGameJson() {
    var gameStr = getString('latestGame');
    // log('load game: $json');
    if (gameStr == null) {
      return null;
    }
    final json = jsonDecode(gameStr);
    return json;
  }

  // 存游戏
  Future<bool> setGameJson(dynamic j) {
    var str = jsonEncode(j);
    // log('save game: $str');
    return setString('latestGame', str);
  }

  // 读玩家信息
  dynamic getPlayerJson() {
    var playerStr = getString('playerData');
    // log('load playerData: $json');
    if (playerStr == null) {
      return null;
    }
    final json = jsonDecode(playerStr);
    return json;
  }

  // 存玩家信息
  Future<bool> setPlayerJson(dynamic j) {
    var str = jsonEncode(j);
    // log('save playerData: $str');
    return setString('playerData', str);
  }

  // 读关卡信息
  dynamic getLevelsJson() {
    var levelsStr = getString('levelsData');
    if (levelsStr == null) {
      return null;
    }
    final json = jsonDecode(levelsStr);
    // log('load levelsData: $json');
    return json;
  }

  // 存关卡信息
  Future<bool> setLevelsJson(dynamic j) {
    var str = jsonEncode(j);
    // log('save levelsData: $str');
    return setString('levelsData', str);
  }
}
