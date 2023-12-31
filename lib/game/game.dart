import 'dart:async';
import 'dart:io';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/data/player_data.dart';
import 'package:scwar/game/game_ui.dart';
import 'package:scwar/game/game_world.dart';
import 'package:scwar/data/local_storage.dart';
import 'package:scwar/utils/game_services_controller.dart';
import 'package:scwar/utils/sound_manager.dart';
import '../config/game_config.dart';
import 'game_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late SCWarGame game;

class SCWarGame extends FlameGame<SCWarWorld> with TapDetector, ScaleDetector {
  bool playing = false;
  SoundManager soundManager = SoundManager();
  late GameManager gameManager;
  late PositionComponent container;
  PlayerData playerData = PlayerData();
  late GameUI ui;
  late LocalStorage localStorage;
  RewardedAd? rewardedAd;
  BuildContext context;
  GamesServicesController gsc = GamesServicesController();

  SCWarGame(this.context)
      : super(
            camera: CameraComponent.withFixedResolution(
                width: GameConfig.fixedWidth, height: GameConfig.fixedHeight),
            world: SCWarWorld()) {
    gameManager = GameManager(this);
    game = this;
  }

  @override
  FutureOr<void> onLoad() async {
    localStorage = await LocalStorage.getInstance();
    // await Flame.images.loadAll([
    //   // 'blue.png',
    //   // 'pause_icon.png',
    // ]);
    await soundManager.load();
    soundManager.soundOn = localStorage.getSoundOn() ?? soundManager.soundOn;
    playerData.loadFromStorage(localStorage);
    await gameManager.load();
    world.showHome();
    overlays.add('home');
    _loadAd();
    if (!kIsWeb && Platform.isIOS) {
      gsc.initialize();
    }
    return super.onLoad();
  }

  AppLocalizations? get locale {
    return AppLocalizations.of(context);
  }

  double get scale {
    return GameConfig.fixedWidth / camera.viewport.size.x;
  }

  void addContent(content) {
    world.add(content);
    // log('addContent');
  }

  @override
  Color backgroundColor() => const Color.fromARGB(0, 0, 0, 0);

  void start({int level = 0}) {
    overlays.clear();
    overlays.add('game');
    camera.viewport.add(ui = GameUI());
    world.startGame();
    gameManager.startGame(level: level);
    playing = true;
  }

  void goToLevel() {
    world.goToLevel();
    if (playing) {
      playing = false;
    }
    overlays.remove('home');
    overlays.add('level');
  }

  void pause() {
    overlays.add('pause');
  }

  void resume() {
    overlays.remove('pause');
  }

  void win() {
    playerData.levels[gameManager.level][0]++;
    playerData.saveLevelsStorage(localStorage);
    submitScore(gameManager.level);
    overlays.add('win');
  }

  void end() {
    overlays.add('gameover');
  }

  void gameOver() {
    // 只有无尽模式记录记录单局游戏数据。
    if (gameManager.level == 0) {
      localStorage.removeGame();
      playerData.updateGameData(gameManager.data);
      playerData.saveStorage(localStorage);
    } else {
      playerData.levels[gameManager.level][1]++;
      playerData.saveLevelsStorage(localStorage);
    }
  }

  void reborn() {
    overlays.remove('gameover');
    gameManager.reborn();
  }

  updateTutorial(int tutorialIdx) {
    playerData.tutorial = tutorialIdx;
    playerData.saveStorage(localStorage);
  }

  void changeTestMode() {
    Config.testMode = !Config.testMode;
    world.home.changeTestMode();
    if (Config.testMode) {
      updateTutorial(0);
    }
  }

  void goHome() {
    world.goHome();
    if (playing) {
      gameManager.clear();
      ui.removeFromParent();
      playing = false;
    }
    overlays.clear();
    overlays.add('home');
  }

  void restart() {
    overlays.clear();
    overlays.add('game');
    gameManager.restartGame();
  }

  void nextLevel() {
    overlays.clear();
    overlays.add('game');
    gameManager.level++;
    gameManager.restartGame();
  }

  void goLeaderboard() {
    if (!kIsWeb && Platform.isIOS) {
      gsc.showLeaderboard();
    }
  }

  void submitScore(int value) {
    if (!kIsWeb && Platform.isIOS) {
      gsc.submitLeaderboardScore(value);
    }
  }

  @override
  void render(Canvas canvas) {
    // var gameSize = gameManager.size;
    // final paint = Paint()..color = Color.fromARGB(255, 33, 243, 47);
    // canvas.drawRect(
    //     Rect.fromLTWH(size.x - gameSize.x, 0, gameSize.x, gameSize.y), paint);
    super.render(canvas);
  }

  void _loadAd() {
    if (kIsWeb || rewardedAd != null) {
      return;
    }
    RewardedAd.load(
        adUnitId: Platform.isIOS ? Config.iosBonusId : Config.androidBonusId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
                rewardedAd = null;
                _loadAd();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                rewardedAd = null;
                _loadAd();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          // Keep a reference to the ad so you can show it later.
          rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }
}
