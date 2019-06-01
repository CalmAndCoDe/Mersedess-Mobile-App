import 'package:mobile_app/Themes/MainTheme.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode { Dark, Light }

class ThemesChanger {
  ThemeData theme = AppTheme().lightMode();
  bool darkmode = false;

  final StreamController themeState = StreamController.broadcast();
  StreamSink get themeIn => themeState.sink;
  Stream get themeStream => themeState.stream;

  final StreamController themeEvents = StreamController();
  Sink get themeEvent => themeEvents.sink;

  ThemesChanger() {
    themeEvents.stream.listen(_mapEventsToState);
  }
  
  static final themeInstance = ThemesChanger();

  factory ThemesChanger.instance() {
    return themeInstance;
  }

  _mapEventsToState(event) {
    switch (event) {
      case ThemeMode.Light:
        theme  = AppTheme().lightMode();
        SharedPreferences.getInstance().then((instance) {
          instance.setBool('theme_mode', false);
        });
        darkmode = false;
        themeState.add(theme);
        break;
      case ThemeMode.Dark:
        theme = AppTheme().darkMode();
        SharedPreferences.getInstance().then((instance) {
          instance.setBool('theme_mode', true);
        });
        darkmode = true;
        themeState.add(theme);
        break;
    }
  }
}


class GetThemeInstance {
  
}