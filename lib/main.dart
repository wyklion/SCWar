import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scwar/layers/game_overlay.dart';
import 'package:scwar/layers/gameover_overlay.dart';
import 'package:scwar/layers/home_overlay.dart';
import 'package:scwar/layers/level_overlay.dart';
import 'package:scwar/layers/pause_overlay.dart';
import 'package:scwar/layers/win_overlay.dart';
import 'package:scwar/utils/ad.dart';
import 'game/game.dart';

class SpaceShooterGame extends FlameGame {}

void main() {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    unawaited(MobileAds.instance.initialize());
  }
  var app = const AppWidget();
  runApp(MaterialApp(home: app));
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blueGrey,
              child: GameWidget(
                game: SCWarGame(),
                overlayBuilderMap: const {
                  'home': buidlHomeOverlay,
                  'pause': buidlPauseOverlay,
                  'game': buidlGameOverlay,
                  'win': buidlWinOverlay,
                  'gameover': buidlGameoverOverlay,
                  'level': buidlLevelOverlay,
                },
              ),
            ),
          ),
          Container(
            height: 80,
            color: Colors.blueGrey,
            child: kIsWeb ? null : const BannerComponent(),
          ),
        ],
      ),
    );
  }
}
