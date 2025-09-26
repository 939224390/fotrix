import 'dart:async';

import 'package:fotrix/api/aria2_api.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:fotrix/utils/aria2_client.dart';
import 'package:fotrix/utils/logger.dart';

class AppAction {
  static Future<void> init() async {
    // 初始化日志
    await logger.initLog();
    // 初始化配置
    await config.loadConfig();
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
  }

  static Future<void> tellWaiting() async {
    final res = await aria2Api.tellWaiting(0, 100);
    taskList.checkWaiting(res);
  }
}
