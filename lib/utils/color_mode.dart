import 'package:flutter/material.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:signals/signals_flutter.dart';

class ColorMode {
  // dark light
  final _themes = {
    'dark': {
      'nav': 0xff191919,
      'side': 0xFF2D2D2D,
      'main': 0xFF343434,
      'text': 0xFFFFFFFF,
      'card': 0xFF2D2D2D,
      'btn': 0xFF606060,
      'switch': 0xFF343434,
      'button': {'default': 0xFF2D2D2D, 'active': 0xFF444444},
    },
    'light': {
      'nav': 0xFF333333,
      'side': 0xFFF4F5F7,
      'main': 0xFFF8F8F8,
      'text': 0xFF000000,
      'card': 0xFFFFFFFF,
      'btn': 0xFFFFFFFF,
      'switch': 0xFFF8F8F8,
      'button': {'default': 0xFFF4F5F7, 'active': 0xFFCCCCCC},
    },
  };

  //获取颜色
  Computed<Color> getColor(String key) {
    return computed(() {
      final theme = config.darkMode ? 'dark' : 'light';
      final color = _themes[theme]![key];
      if (color is Map) {
        return Color(color['default']);
      }
      return Color(color as int);
    });
  }

  //获取按钮颜色
  Computed<Color> activeColor(int index) {
    return computed(() {
      final theme = config.darkMode ? 'dark' : 'light';
      final buttonColors = _themes[theme]!['button'] as Map<String, dynamic>;
      return Color(
        pInf.mInd == index
            ? buttonColors['active'] as int
            : buttonColors['default'] as int,
      );
    });
  }
}


ColorMode colorMode = ColorMode();

class ColorTheme {
  static final navColor = colorMode.getColor("nav");
  static final sideColor = colorMode.getColor("side");
  static final mainColor = colorMode.getColor("main");
  static final textColor = colorMode.getColor("text");
  static final cardColor = colorMode.getColor("card");
  static final buttonColor = colorMode.getColor("button");
  static final btnColor = colorMode.getColor("btn");
  static final switchColor = colorMode.getColor("switch");
}
