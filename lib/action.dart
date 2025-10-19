import 'dart:async';
import 'dart:io';

import 'package:fotrix/api/aria2_api.dart';
import 'package:fotrix/api/config_api.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:fotrix/utils/aria2_client.dart';
import 'package:fotrix/utils/logger.dart';
import 'package:fotrix/utils/tray_service.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppAction {
  static Future<void> init() async {
    // 初始化启动器
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    // 初始化日志
    await logger.initLog();
    await logger.info("------Start App------");
    // 初始化配置
    await Hive.initFlutter();
    await initConfig();
    await config.loadConfigBox();
  }

  static Future<void> startAria2() async {
    // 初始化aria2
    await a2c.start();

    await getAria2Version();

    // 检查aria2版本
    Timer.periodic(Duration(seconds: 5), (_) async {
      await getAria2Version();
    });
    //
    Timer.periodic(Duration(seconds: 1), (_) async {
      await tellActive();
      await tellWaiting();
    });
  }

  static Future<void> getAria2Version() async {
    final res = await aria2Api.getAria2Version();
    config.aria2Version = res;
  }

  static Future<void> tellActive() async {
    final res = await aria2Api.tellActive();
    taskList.checkActive(res);
    if (res.isEmpty) {
      if (ts.status == "active") {
        ts.changeTrayIcon("default");
      }
    } else {
      if (ts.status == "default") {
        ts.changeTrayIcon("active");
      }
    }
  }

  static Future<void> tellWaiting() async {
    final res = await aria2Api.tellWaiting(0, 100);
    taskList.checkWaiting(res);
  }
}
