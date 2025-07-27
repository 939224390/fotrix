import 'dart:async';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/logger.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:fotrix/utils/aria2_client.dart';

class Aria2Manager {
  final a2c = Aria2Client();

  //启动aria2服务
  Future<void> start() async {
    await a2c.start();
    await getAria2Version();
    await a2c.listen();
    await taskList.start();
  }

  Future<void> updateConfig() async {
    await a2c.send("aria2.changeGlobalOption", [
      {
        'dir': config.savePath,
        'max-concurrent-downloads': config.maxDown,
        'max-connection-per-server': config.threadCount,
      },
    ]);
    await a2c.writeConf();
  }

  Future<void> shutdown() async {
    await a2c.shutdown();
  }

  Future<void> getAria2Version() async {
    final res = await a2c.send('aria2.getVersion');
    if (res.code == -1) {
      logger.error("获取Aria2版本失败: ${res.data}");
      config.aria2Version = "未连接";
      return;
    }
    config.aria2Version = res.data['version'];
  }

  //添加任务
  Future<String> addTask(String url) async {
    final res = await a2c.send('aria2.addUri', [
      [url],
    ]);
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error(res.data);
      return "";
    }
  }

  //获取下载列表
  Future<List<dynamic>> tellActive() async {
    final res = await a2c.send('aria2.tellActive');
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error(res.data);
      return [];
    }
  }

  //获取等待列表
  Future<List<dynamic>> tellWaiting(int start, int num) async {
    final res = await a2c.send('aria2.tellWaiting', [start, num]);
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error(res.data);
      return [];
    }
  }

  // 获取下载状态
  Future<Map<String, dynamic>> tellStatus(String gid) async {
    final res = await a2c.send('aria2.tellStatus', [gid]);
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error(res.data);
      return {};
    }
  }

  // 暂停任务
  Future<String> pauseTask(String gid) async {
    final res = await a2c.send('aria2.pause', [gid]);
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error(res.data);
      return "";
    }
  }

  //暂停全部任务
  Future<String> pauseAll() async {
    final res = await a2c.send('aria2.pauseAll');
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error(res.data);
      return "";
    }
  }

  //继续任务
  Future<String> resumeTask(String gid) async {
    final res = await a2c.send('aria2.unpause', [gid]);
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error(res.data);
      return "";
    }
  }

  //继续全部任务
  Future<String> resumeAll() async {
    final res = await a2c.send('aria2.unpauseAll');
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error(res.data);
      return "";
    }
  }

  //删除任务
  Future<String> removeTask(String gid) async {
    final res = await a2c.send('aria2.remove', [gid]);
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error(res.data);
      return "";
    }
  }
}

Aria2Manager a2M = Aria2Manager();
