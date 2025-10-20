import 'package:fotrix/api/config_api.dart';
import 'package:fotrix/utils/logger.dart';
import 'package:fotrix/types/types.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:signals/signals.dart';
import "package:fotrix/api/aria2_api.dart";

class Config {
  final _darkMode = signal(true);
  late bool powerBoot;
  late int _threadCount;
  late String savePath;
  late int maxDown;

  late final _aria2Version = signal("-1");
  String version = "0.0.1";

  bool get darkMode => _darkMode.value;
  int get threadCount => _threadCount;
  String get aria2Version => _aria2Version.value;

  set threadCount(int count) {
    _threadCount = (count <= 16 && count >= 0) ? count : 1;
  }

  set aria2Version(String value) {
    _aria2Version.value = value;
  }

  //切换模式
  void changeTheme() {
    _darkMode.value = !_darkMode.value;
    setDarkMode(darkMode);
  }

  Future<void> loadConfigBox() async {
    try {
      await logger.info("正在加载配置文件");
      _darkMode.value = getDarkMode;
      powerBoot = await launchAtStartup.isEnabled();
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
      setThreadCount(threadCount);
      setMaxDown(maxDown);
      setSavePath(savePath);
      if (powerBoot == true) {
        launchAtStartup.enable();
      } else {
        launchAtStartup.disable();
      }

      await aria2Api.updateConfig(
        UConfig(savePath: savePath, threadCount: threadCount, maxDown: maxDown),
      );
    } catch (e) {
      await logger.error("保存配置文件失败 $e");
    }
  }
}

Config config = Config();
