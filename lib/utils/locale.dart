import 'package:flutter/material.dart';

class MyLocale {
  MyLocale._();
  static final MyLocale _instance = MyLocale._();
  static MyLocale get instance => _instance;
  static void change(String name) {
    instance.changeLocale(Locale(name));
  }

  static void changeNext() {
    instance.currentIdx++;
    if (instance.currentIdx >= instance.localeList.length) {
      instance.currentIdx = 0;
    }
    instance.changeLocale(Locale(instance.localeList[instance.currentIdx]));
  }

  int currentIdx = 1;
  List<String> localeList = ['en', 'zh', 'ja', 'ko', 'es', 'fr', 'de', 'ru'];
  late Function(Locale locale) changeLocale;
}
