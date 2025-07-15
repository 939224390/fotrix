import 'dart:async';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/logger.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:fotrix/utils/aria2_client.dart';

class Aria2Manager {
  final a2c = Aria2Client();

  //启动aria2服务
  start() async {
    await a2c.start();
    await getAria2Version();
    await a2c.listen();
    await taskList.start();
  }

  updateConfig() async {
    await a2c.send("aria2.changeGlobalOption", [
      {
        'dir': config.savePath,
        'max-concurrent-downloads': config.maxDown,
        'max-connection-per-server': config.threadCount,
      },
    ]);
    await a2c.writeConf();
  }

  shutdown() async {
    await a2c.shutdown();
  }

  Future<void> getAria2Version() async {
    final res = await a2c.send('aria2.getVersion');
    if (res == -1) {
      logger.error("获取Aria2版本失败");
      config.aria2Version = "未连接";
      return;
    }
    config.aria2Version = res['version'];
  }

  Future<bool> isConnecting() async {
    try {
      final res = await a2c.send('aria2.getVersion');
      if (res == -1) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  //添加任务
  Future<String> addTask(String url) async {
    return await a2c.send('aria2.addUri', [
      [url],
    ]);
  }

  //获取下载列表
  Future<List<dynamic>> tellActive() async {
    return await a2c.send('aria2.tellActive');
  }

  //获取等待列表
  Future<List<dynamic>> tellWaiting(int start, int num) async {
    return await a2c.send('aria2.tellWaiting', [start, num]);
  }

  // 获取下载状态
  Future<Map<String, dynamic>> tellStatus(String gid) async {
    return await a2c.send('aria2.tellStatus', [gid]);
  }

  // 暂停任务
  Future<String> pauseTask(String gid) async {
    return await a2c.send('aria2.pause', [gid]);
  }

  //暂停全部任务
  Future<String> pauseAll() async {
    return await a2c.send('aria2.pauseAll');
  }

  //继续任务
  Future<String> resumeTask(String gid) async {
    return await a2c.send('aria2.unpause', [gid]);
  }

  //继续全部任务
  Future<String> resumeAll() async {
    return await a2c.send('aria2.unpauseAll');
  }

  //删除任务
  Future<String> removeTask(String gid) async {
    return await a2c.send('aria2.remove', [gid]);
  }
}

Aria2Manager a2M = Aria2Manager();
