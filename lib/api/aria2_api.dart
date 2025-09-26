import 'package:fotrix/types/types.dart';
import 'package:fotrix/utils/aria2_client.dart';
import 'package:fotrix/utils/logger.dart';

class Aria2Api {
  //获取aria2版本
  Future<String> getAria2Version() async {
    final res = await a2c.send("aria2.getVersion");
    if (res.code == 1) {
      return res.data['version'];
    } else {
      logger.error("获取Aria2版本失败: ${res.data}");
      return "-1";
    }
  }

  //添加任务
  Future<String> addTask(String url) async {
    final res = await a2c.send('aria2.addUri', [
      [url],
    ]);
    if (res.code == 1) {
      return res.data;
    } else {
      logger.error("添加任务失败: ${res.data}");
      return "-1";
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

  //更新aria2配置
  Future<void> updateConfig(UConfig config) async {
    await a2c.send("aria2.changeGlobalOption", [
      {
        'dir': config.savePath,
        'max-concurrent-downloads': config.maxDown,
        'max-connection-per-server': config.threadCount,
      },
    ]);
  }

  Future<void> shutdown() async {
    final res = await a2c.send('aria2.shutdown');
    if (res.code == 1 && res.data == 'OK') {
      a2c.shutdown();
    } else {
      logger.error(res.data);
    }
  }
}

final aria2Api = Aria2Api();
