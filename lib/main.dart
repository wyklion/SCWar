import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/layers/game_overlay.dart';
import 'package:scwar/layers/gameover_overlay.dart';
import 'package:scwar/layers/home_overlay.dart';
import 'package:scwar/layers/level_overlay.dart';
import 'package:scwar/layers/pause_overlay.dart';
import 'package:scwar/layers/win_overlay.dart';
import 'package:scwar/utils/ad.dart';
import 'package:scwar/utils/locale.dart';
import 'game/game.dart';

void main() {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    unawaited(MobileAds.instance.initialize());
  }
  var app = const AppWidget();
  runApp(app);
}

/// A simple app that loads a rewarded ad.
class AppWidget extends StatefulWidget {
  const AppWidget({super.key});
  @override
  AppWidgetState createState() => AppWidgetState();
}

class AppWidgetState extends State<AppWidget> {
  Locale? _locale;
  @override
  void initState() {
    super.initState();
    MyLocale.instance.changeLocale = (Locale locale) {
      setState(() {
        _locale = locale;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return MediaQuery(
          //设置全局的文字的textScaleFactor为1.0，文字不再随系统设置改变
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.blueGrey,
                child: const MyGameWidget(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              color: Colors.blueGrey,
              child: kIsWeb ? null : const BannerComponent(),
            ),
          ],
        ),
      ),
    );
  }
}

class MyGameWidget extends StatelessWidget {
  const MyGameWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: SCWarGame(context),
      overlayBuilderMap: const {
        'home': buidlHomeOverlay,
        'pause': buidlPauseOverlay,
        'game': buidlGameOverlay,
        'win': buidlWinOverlay,
        'gameover': buidlGameoverOverlay,
        'level': buidlLevelOverlay,
      },
    );
  }
}
