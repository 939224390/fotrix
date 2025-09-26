import 'dart:io';
import 'package:fotrix/utils/logger.dart';
import 'package:fotrix/types/types.dart';
import 'package:fotrix/utils/cross.dart';
import 'dart:convert';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:signals/signals.dart';
import "package:fotrix/api/aria2_api.dart";

class Config {
  final _darkMode = signal(true);
  bool _powerBoot = false;

  int _threadCount = 6;
  String savePath = "D:\\Download";
  int maxDown = 5;

  late final _aria2Version = signal("-1");
  String version = "0.1.3";

  bool get darkMode => _darkMode.value;
  int get threadCount => _threadCount;
  bool get powerBoot => _powerBoot;
  String get aria2Version => _aria2Version.value;

  set threadCount(int count) {
    _threadCount = (count <= 16 && count >= 0) ? count : 1;
  }

  set powerBoot(bool value) {
    _powerBoot = value;
    if (_powerBoot == true) {
      launchAtStartup.enable();
    } else {
      launchAtStartup.disable();
    }
  }

  set aria2Version(String value) {
    _aria2Version.value = value;
  }

  //切换模式
  void changeTheme() {
    _darkMode.value = !_darkMode.value;
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
      _darkMode.value = config['darkMode'] ?? darkMode;
      powerBoot = config['powerBoot'] ?? powerBoot;

      savePath = config['savePath'] ?? savePath;
      threadCount = config['threadCount'] ?? threadCount;
      maxDown = config['maxDown'] ?? maxDown;

      await logger.info("加载配置文件");
    } catch (e) {
      await logger.error("加载配置文件失败 $e");
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

      await aria2Api.updateConfig(
        UConfig(savePath: savePath, threadCount: threadCount, maxDown: maxDown),
      );
    } catch (e) {
      await logger.error("保存配置文件失败 $e");
    }
  }
}

Config config = Config();
