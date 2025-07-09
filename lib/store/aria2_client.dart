import "dart:async";
import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:fotrix/store/logger.dart";
import "package:fotrix/utils/cross.dart";
import "package:fotrix/store/config.dart";
import "package:fotrix/store/task_list.dart";
import 'package:dio/dio.dart';

class Aria2Server {
  final String httpUrl = "http://localhost:16800/jsonrpc";
  final String? secret = '';
  final Duration timeout = Duration(seconds: 10);
  final Dio dio = Dio();
  Process? aria2Process;

  start() async {
    final isRunning = await Cross().isAria2Running();
    if (isRunning) {
      final v = await send('aria2.getVersion');
      if (v != -1) {
        return;
      }
    }
    await _startAria2();
  }

  Future<dynamic> send(String method, [List<dynamic>? params]) async {
    try {
      final response = await dio
          .post(
            httpUrl,
            options: Options(headers: {'Content-Type': 'application/json'}),
            data: json.encode({
              'jsonrpc': '2.0',
              'method': method,
              'params': params ?? [],
              'id': DateTime.now().millisecondsSinceEpoch,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        if (data['error'] != null) {
          runLog.log("Aria2请求错误: ${data['error']}");
          return -1;
        }
        return data['result'];
      } else {
        runLog.log('HTTP error: ${response.statusCode}');
        return -1;
      }
    } catch (e) {
      runLog.log("请求失败: $e");
      return -1;
    }
  }

  _startAria2() async {
    try {
      await Cross().createAria2();

      // 获取应用目录
      final aria2Path = await Cross().getAria2Path();
      final aria2ConfPath = await Cross().getAria2ConfPath();
      final aria2LogPath = await Cross().getAria2LogPath();

      // 启动 Aria2 进程
      aria2Process = await Process.start(aria2Path, [
        '--dir=${config.savePath}',
        '--max-concurrent-downloads=${config.maxDown}',
        '--max-connection-per-server=${config.threadCount}',
        '--conf-path=$aria2ConfPath',
        '--rpc-listen-port=16800',
        '--save-session-interval=60',
        '--continue=true',
        '--log=$aria2LogPath',
        '--log-level=debug',
      ]);
      aria2Process?.stdout.transform(utf8.decoder).listen((data) {
        debugPrint("Aria2 stdout: $data");
      });
    } catch (e) {
      runLog.log("Aria2服务启动失败 $e");
    }
  }
}

class Aria2Client {
  final a2Server = Aria2Server();

  Process? aria2Process;

  //启动aria2服务
  start() async {
    await a2Server.start();
    await getAria2Version();
    await taskList.start();
  }

  void shutdown() async {
    await a2Server.send("aria2.shutdown");
    aria2Process?.kill();
  }

  Future<void> getAria2Version() async {
    final res = await a2Server.send('aria2.getVersion');
    if (res == -1) {
      runLog.log("获取Aria2版本失败");
      return;
    }
    config.aria2Version = res['version'];
  }

  Future<bool> isConnecting() async {
    try {
      final res = await a2Server.send('aria2.getVersion');
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
    return await a2Server.send('aria2.addUri', [
      [url],
    ]);
  }

  //获取下载列表
  Future<List<dynamic>> tellActive() async {
    return await a2Server.send('aria2.tellActive');
  }

  //获取等待列表
  Future<List<dynamic>> tellWaiting(int start, int num) async {
    return await a2Server.send('aria2.tellWaiting', [start, num]);
  }

  // 获取下载状态
  Future<Map<String, dynamic>> tellStatus(String gid) async {
    return await a2Server.send('aria2.tellStatus', [gid]);
  }

  // 暂停任务
  Future<String> pauseTask(String gid) async {
    return await a2Server.send('aria2.pause', [gid]);
  }

  //暂停全部任务
  Future<String> pauseAll() async {
    return await a2Server.send('aria2.pauseAll');
  }

  //继续任务
  Future<String> resumeTask(String gid) async {
    return await a2Server.send('aria2.unpause', [gid]);
  }

  //继续全部任务
  Future<String> resumeAll() async {
    return await a2Server.send('aria2.unpauseAll');
  }

  //删除任务
  Future<String> removeTask(String gid) async {
    return await a2Server.send('aria2.remove', [gid]);
  }
}

Aria2Client aria2Client = Aria2Client();
