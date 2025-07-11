import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fotrix/store/logger.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/utils/cross.dart';
import 'dart:convert';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:signals/signals.dart';

class Config {
  final _darkMode = signal(true);
  int _threadCount = 6;
  final _savePath = signal("D:\\Download");
  final _powerBoot = signal(false);
  int maxDown = 5;
  late final _aria2Version = signal("");
  late final _aria2Connected = signal(false);
  String version = "0.1.2";

  bool get darkMode => _darkMode.value;
  int get threadCount => _threadCount;
  bool get powerBoot => _powerBoot.value;
  String get aria2Version => _aria2Version.value;
  bool get aria2Connected => _aria2Connected.value;
  String get savePath => _savePath.value;

  set threadCount(int count) {
    _threadCount = (count < 64 && count >= 0) ? count : 1;
  }

  set powerBoot(bool value) {
    _powerBoot.value = value;
    if (_powerBoot.value == true) {
      launchAtStartup.enable();
    } else {
      launchAtStartup.disable();
    }
  }

  set savePath(String value) {
    _savePath.value = value;
  }

  set aria2Version(String value) {
    _aria2Version.value = value;
  }

  set aria2Connected(bool value) {
    _aria2Connected.value = value;
  }

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

  //切换模式
  void changeTheme() {
    _darkMode.value = !_darkMode.value;
  }

  late final darkModeIcon = computed(
    () => darkMode ? Icons.dark_mode : Icons.light_mode,
  );

  //获取颜色
  Computed<Color> getColor(String key) {
    return computed(() {
      final theme = _darkMode.value ? 'dark' : 'light';
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
      final theme = darkMode ? 'dark' : 'light';
      final buttonColors = _themes[theme]!['button'] as Map<String, dynamic>;
      return Color(
        pInf.mInd == index
            ? buttonColors['active'] as int
            : buttonColors['default'] as int,
      );
    });
  }

  //读取配置文件
  Future<void> loadConfig() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      launchAtStartup.setup(
        appName: packageInfo.appName,
        appPath: Platform.resolvedExecutable,
      );

      await Cross().createConfig();
      final configPath = "${await Cross().getDocPath()}/config.json";
      final jsonString = await File(configPath).readAsString();
      final config = jsonDecode(jsonString);
      savePath = config['savePath'] ?? savePath;
      threadCount = config['threadCount'] ?? threadCount;
      _darkMode.value = config['darkMode'] ?? darkMode;
      powerBoot = config['powerBoot'] ?? powerBoot;
      maxDown = config['maxDown'] ?? maxDown;

      await runLog.log("加载配置文件");
    } catch (e) {
      await runLog.log("加载配置文件失败 $e");
    }
  }

  //保存配置文件
  Future<void> saveConfig() async {
    try {
      final configPath = "${await Cross().getDocPath()}/config.json";
      final file = File(configPath);
      await file.writeAsString(
        jsonEncode({
          'savePath': savePath,
          'threadCount': threadCount,
          'darkMode': darkMode,
          'powerBoot': powerBoot,
          'maxDown': maxDown,
        }),
      );
    } catch (e) {
      await runLog.log("保存配置文件失败 $e");
    }
  }
}

Config config = Config();

class ColorTheme {
  static final navColor = config.getColor("nav");
  static final sideColor = config.getColor("side");
  static final mainColor = config.getColor("main");
  static final textColor = config.getColor("text");
  static final cardColor = config.getColor("card");
  static final buttonColor = config.getColor("button");
  static final btnColor = config.getColor("btn");
  static final switchColor = config.getColor("switch");
}
