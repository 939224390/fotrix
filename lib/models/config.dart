import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:fotrix/components/common/cross.dart';
import 'dart:convert';
import 'package:launch_at_startup/launch_at_startup.dart';

class Config with ChangeNotifier {
  bool _darkMode = true;
  int _threadCount = 6;
  String savePath = "D:\\Download";
  bool _powerBoot = false;

  bool get darkMode => _darkMode;
  int get threadCount => _threadCount;
  bool get powerBoot => _powerBoot;
  set threadCount(int count) {
    _threadCount = (count < 64 && count >= 0) ? count : 1;
  }

  set powerBoot(bool value) {
    _powerBoot = value;
    if (_powerBoot == true) {
      launchAtStartup.enable();
    } else {
      launchAtStartup.disable();
    }
  }

  // dark light
  final _themes = {
    'dark': {
      'side': 0xff191919,
      'bar': 0xFF2D2D2D,
      'main': 0xFF343434,
      'text': 0xFFFFFFFF,
      'card': 0xFF2D2D2D,
      'button': {'default': 0xFF2D2D2D, 'active': 0xFF444444},
    },
    'light': {
      'side': 0xFF333333,
      'bar': 0xFFF4F5F7,
      'main': 0xFFF8F8F8,
      'text': 0xFF000000,
      'card': 0xFFFFFFFF,
      'button': {'default': 0xFFF4F5F7, 'active': 0xFFCCCCCC},
    },
  };

  //切换模式
  void toggleTheme() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  //读取配置文件
  Future<void> loadConfig() async {
    launchAtStartup.setup(
      appName: 'Fotrix',
      appPath: Platform.resolvedExecutable,
    );
    Cross().createConfig();
    final configPath = "${await Cross().getDocPath()}/config.json";
    final jsonString = await File(configPath).readAsString();
    final config = jsonDecode(jsonString);
    savePath = config['savePath'] ?? savePath;
    threadCount = config['threadCount'] ?? _threadCount;
    _darkMode = config['darkMode'] ?? _darkMode;
    powerBoot = config['powerBoot'] ?? _powerBoot;

    notifyListeners();
  }

  //保存配置文件
  Future<void> saveConfig() async {
    final configPath = "${await Cross().getDocPath()}/config.json";
    final file = File(configPath);
    await file.writeAsString(
      jsonEncode({
        'savePath': savePath,
        'threadCount': threadCount,
        'darkMode': darkMode,
        'powerBoot': powerBoot,
      }),
    );

    notifyListeners();
  }

  //获取颜色
  Color getColor(String key) {
    final theme = darkMode ? 'dark' : 'light';
    final color = _themes[theme]![key];
    if (color is Map) {
      return Color(color['default']);
    }
    return Color(color as int);
  }

  //获取按钮颜色
  Color currActiveColor(int activeIndex, int index) {
    final theme = darkMode ? 'dark' : 'light';
    final buttonColors = _themes[theme]!['button'] as Map<String, dynamic>;

    return Color(
      activeIndex == index
          ? buttonColors['active'] as int
          : buttonColors['default'] as int,
    );
  }
}

Config config = Config();
