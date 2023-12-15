import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scwar/config/config.dart';

class BannerComponent extends StatefulWidget {
  const BannerComponent({super.key});

  @override
  BannerComponentState createState() => BannerComponentState();
}

class BannerComponentState extends State<BannerComponent> {
  late BannerAd _bannerAd;
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: Platform.isIOS
          ? Config.iosBannerId
          : Config.androidBannerId, // 替换为你的 AdMob 横幅广告单元 ID
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          // 广告加载成功时的回调
          log('BannerAd loaded: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // 广告加载失败时的回调
          log('BannerAd failed to load: ${ad.adUnitId}, $error');
          ad.dispose();
        },
      ),
    );
    // 加载广告
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }
}
