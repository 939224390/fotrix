import 'package:flutter/material.dart';
import 'package:fotrix/store/config.dart';
import 'package:signals/signals.dart';

class FotrixThemeData {
  final Color nav;
  final Color side;
  final Color main;
  final Color text;
  final Color card;
  final Color btn;
  final Color sswitch;
  final Color tabDefault;
  final Color tabActive;

  const FotrixThemeData({
    required this.nav,
    required this.side,
    required this.main,
    required this.text,
    required this.card,
    required this.btn,
    required this.sswitch,
    required this.tabDefault,
    required this.tabActive,
  });
}

extension FotrixTheme on ThemeData {
  FotrixThemeData get fTheme {
    if (brightness == Brightness.light) {
      return const FotrixThemeData(
        nav: Color(0xFF333333),
        side: Color(0xFFF4F5F7),
        main: Color(0xFFF8F8F8),
        text: Color(0xFF000000),
        card: Color(0xFFFFFFFF),
        btn: Color(0xFFFFFFFF),
        sswitch: Color(0xFFF8F8F8),
        tabDefault: Color(0xFFF4F5F7),
        tabActive: Color(0xFFCCCCCC),
      );
    } else {
      return const FotrixThemeData(
        nav: Color(0xff191919),
        side: Color(0xFF2D2D2D),
        main: Color(0xFF343434),
        text: Color(0xFFFFFFFF),
        card: Color(0xFF2D2D2D),
        btn: Color(0xFF606060),
        sswitch: Color(0xFF343434),
        tabDefault: Color(0xFF2D2D2D),
        tabActive: Color(0xFF444444),
      );
    }
  }
}

class ThemeManager {
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontFamily: 'HarmonyOS Sans'),
      displayMedium: base.displayMedium?.copyWith(fontFamily: 'HarmonyOS Sans'),
      displaySmall: base.displaySmall?.copyWith(fontFamily: 'HarmonyOS Sans'),
      headlineLarge: base.headlineLarge?.copyWith(fontFamily: 'HarmonyOS Sans'),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: 'HarmonyOS Sans',
      ),
      headlineSmall: base.headlineSmall?.copyWith(fontFamily: 'HarmonyOS Sans'),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: 'HarmonyOS Sans',
        fontWeight: FontWeight.w500,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: 'HarmonyOS Sans',
        fontWeight: FontWeight.w500,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: 'HarmonyOS Sans',
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(fontFamily: 'HarmonyOS Sans'),
      bodyMedium: base.bodyMedium?.copyWith(fontFamily: 'HarmonyOS Sans'),
      bodySmall: base.bodySmall?.copyWith(fontFamily: 'HarmonyOS Sans'),
      labelLarge: base.labelLarge?.copyWith(fontFamily: 'HarmonyOS Sans'),
      labelMedium: base.labelMedium?.copyWith(fontFamily: 'HarmonyOS Sans'),
      labelSmall: base.labelSmall?.copyWith(fontFamily: 'HarmonyOS Sans'),
    );
  }

  static ThemeData get lightTheme {
    final theme = ThemeData.light();
    return theme.copyWith(textTheme: _buildTextTheme(theme.textTheme));
  }

  static ThemeData get darkTheme {
    final theme = ThemeData.dark();
    return theme.copyWith(textTheme: _buildTextTheme(theme.textTheme));
  }

  static Computed<ThemeData> get curTheme {
    return computed(() => config.darkMode ? darkTheme : lightTheme);
  }
}
