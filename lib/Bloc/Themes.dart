import 'package:mobile_app/Themes/MainTheme.dart';
import 'package:flutter/material.dart';
import 'dart:async';

enum ThemeMode { Dark, Light }

class ThemesChanger {
  ThemeData theme = AppTheme().lightMode();

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
        themeState.add(theme);
        break;
      case ThemeMode.Dark:
        theme = AppTheme().darkMode();
        themeState.add(theme);
        break;
    }
  }
}


class GetThemeInstance {
  
}