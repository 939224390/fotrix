import "dart:async";
import "dart:convert";
import "dart:io";
import "package:fotrix/store/logger.dart";
import "package:fotrix/utils/cross.dart";
import "package:fotrix/store/config.dart";
import "package:fotrix/store/task_list.dart";
import 'package:dio/dio.dart';
import "package:web_socket_channel/io.dart";

class Aria2Server {
  final String httpUrl = "http://localhost:16800/jsonrpc";
  final String wsUrl = "ws://localhost:16800/jsonrpc";
  final Duration timeout = Duration(seconds: 10);
  final Dio dio = Dio();
  IOWebSocketChannel? wsChannel;
  Process? aria2Process;

  start() async {
    final isRunning = await Cross().isAria2Running();
    if (isRunning) {
      final v = await send('aria2.getVersion');
      if (v != -1) {
        wsChannel = IOWebSocketChannel.connect(wsUrl);
        return;
      }
    }

    await _startAria2();
    wsChannel = IOWebSocketChannel.connect(wsUrl);
  }

  listen() async {
    wsChannel!.stream.listen((data) {
      final res = jsonDecode(data);
      if (res['method'] == 'aria2.onDownloadStart') {
        final list = res['params'];
        taskList.checkActive(list);
      }
    });
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
          logger.error("Aria2请求错误: ${data['error']}");
          return -1;
        }
        return data['result'];
      } else {
        logger.error('HTTP error: ${response.statusCode}');
        return -1;
      }
    } catch (e) {
      logger.error("请求失败: $e");
      return -1;
    }
  }

  writeConf() async {
    try {
      final aria2ConfPath = await Cross().getAria2ConfPath();
      final aria2LogPath = await Cross().getAria2LogPath();
      final aria2Conf = File(aria2ConfPath);

      final confContent = StringBuffer();
      confContent.write("enable-rpc=true\n");
      confContent.write("rpc-allow-origin-all=true\n");
      confContent.write("rpc-listen-all=true\n");
      confContent.write("rpc-max-request-size=10M\n");
      confContent.write("rpc-save-upload-metadata=true\n");
      confContent.write("min-split-size=1M\n");
      confContent.write("disk-cache=16M\n");
      confContent.write("file-allocation=trunc\n");
      confContent.write("continue=true\n");
      confContent.write("rpc-listen-port=16800\n");
      confContent.write("save-session-interval=60\n");
      confContent.write("max-concurrent-downloads=${config.maxDown}\n");
      confContent.write("max-connection-per-server=${config.threadCount}\n");
      confContent.write("log=$aria2LogPath\n");
      confContent.write("dir=${config.savePath}\n");
      if (!await aria2Conf.exists()) {
        await aria2Conf.create();
      } else {
        await aria2Conf.writeAsString("");
      }

      await aria2Conf.writeAsString(confContent.toString());
    } catch (e) {
      logger.error("创建Aria2配置文件失败 $e");
    }
  }

  _startAria2() async {
    try {
      await Cross().createAria2();

      // 获取应用目录
      final aria2Path = await Cross().getAria2Path();
      final aria2ConfPath = await Cross().getAria2ConfPath();
      await writeConf();

      // 启动 Aria2 进程
      aria2Process = await Process.start(aria2Path, [
        '--conf-path=$aria2ConfPath',
      ]);
      aria2Process?.stdout.transform(utf8.decoder).listen((data) {
        data;
      });
    } catch (e) {
      logger.error("Aria2服务启动失败 $e");
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
    config.aria2Connected = await isConnecting();
    Timer.periodic(Duration(seconds: 5), (timer) async {
      config.aria2Connected = await isConnecting();
    });
    await a2Server.listen();

    // await getGlobalOption();
    // await changeGlobalOption();
    // await getGlobalOption();

    await taskList.start();
  }

  shutdown() async {
    await a2Server.send("aria2.shutdown");
    aria2Process?.kill();
  }

  //   Future<void> changeGlobalOption() async {
  //     await a2Server.send("aria2.changeGlobalOption", [
  //       {"dir": "D:\\Download"},
  //     ]);
  //   }

  //   Future<void> getGlobalOption() async {
  //     final res = await a2Server.send("aria2.getGlobalOption");
  //   }

  Future<void> getAria2Version() async {
    final res = await a2Server.send('aria2.getVersion');
    if (res == -1) {
      logger.error("获取Aria2版本失败");
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
