import 'package:fotrix/api/config_api.dart';
import 'package:fotrix/utils/logger.dart';
import 'package:fotrix/types/types.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:signals/signals.dart';
import "package:fotrix/api/aria2_api.dart";

class Config {
  final _darkMode = signal(true);
  late bool _powerBoot;
  late int _threadCount;
  late String savePath;
  late int maxDown;

  late final _aria2Version = signal("-1");
  String version = "0.0.1";

  bool get darkMode => _darkMode.value;
  int get threadCount => _threadCount;
  bool get powerBoot => _powerBoot;
  String get aria2Version => _aria2Version.value;

  set threadCount(int count) {
    _threadCount = (count <= 16 && count >= 0) ? count : 1;
  }

  set powerBoot(bool value) {
    _powerBoot = value;
    try {
      if (_powerBoot == true) {
        launchAtStartup.enable();
      } else {
        launchAtStartup.disable();
      }
    } catch (e) {
      logger.error("设置开机自启失败 $e");
    }
  }

  set aria2Version(String value) {
    _aria2Version.value = value;
  }

  //切换模式
  void changeTheme() {
    _darkMode.value = !_darkMode.value;
  }

  Future<void> loadConfigBox() async {
    try {
      await logger.info("正在加载配置文件");
      _darkMode.value = getDarkMode;
      powerBoot = getPowerBoot;
      threadCount = getThreadCount;
      maxDown = getMaxDown;
      savePath = getSavePath;
      await logger.info("加载配置文件");
    } catch (e) {
      await logger.error("加载配置文件失败 $e");
    }
  }

  void saveConfigBox() async {
    try {
      setDarkMode(darkMode);
      setPowerBoot(powerBoot);
      setThreadCount(threadCount);
      setMaxDown(maxDown);
      setSavePath(savePath);
      await aria2Api.updateConfig(
        UConfig(savePath: savePath, threadCount: threadCount, maxDown: maxDown),
      );
    } catch (e) {
      await logger.error("保存配置文件失败 $e");
    }
  }
}

Config config = Config();
