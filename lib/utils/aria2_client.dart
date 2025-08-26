import "dart:async";
import "dart:convert";
import "dart:io";
import "package:fotrix/store/logger.dart";
import "package:fotrix/store/result.dart";
import "package:fotrix/store/task_list.dart";
import "package:fotrix/utils/cross.dart";
import "package:fotrix/store/config.dart";
import 'package:dio/dio.dart';
import "package:web_socket_channel/io.dart";

class Aria2Client {
  final String httpUrl = "http://localhost:16800/jsonrpc";
  final String wsUrl = "ws://localhost:16800/jsonrpc";
  final Duration timeout = Duration(seconds: 10);
  final Dio dio = Dio();
  IOWebSocketChannel? wsChannel;
  Process? aria2Process;

  Future<void> start() async {
    final isRunning = await Cross().isAria2Running();
    if (isRunning) {
      final v = await send('aria2.getVersion');
      if (v.code == 1) {
        wsChannel = IOWebSocketChannel.connect(wsUrl);
        logger.info('aria2已启动');
        return;
      }
    }

    await _startAria2();

    bool isStartAria2 = false;
    int retryCount = 0;
    while (!isStartAria2) {
      isStartAria2 = await _startAria2();
      retryCount++;
      if (retryCount > 5) {
        logger.error("Aria2服务启动失败");
        return;
      }
    }

    wsChannel = IOWebSocketChannel.connect(wsUrl);
    logger.info('aria2已启动');
  }

  Future<void> listen() async {
    wsChannel!.stream.listen((data) async {
      final res = jsonDecode(data);
      switch (res['method']) {
        case 'aria2.onDownloadStart':
          final list = res['params'];
          await taskList.checkActive(list);
          break;
        case "aria2.onDownloadComplete":
          break;
      }
    });
  }

  Future<Result> send(String method, [List<dynamic>? params]) async {
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
          return Result(-1, "Aria2请求错误: ${data['error']}");
        }
        return Result(1, data['result']);
      } else {
        return Result(-1, "HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      return Result(-1, "请求失败: $e");
    }
  }

  Future<void> writeConf() async {
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

  Future<bool> _startAria2() async {
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
      return true;
    } catch (e) {
      logger.error("Aria2服务启动失败 $e");
      return false;
    }
  }

  Future<void> shutdown() async {
    await send("aria2.shutdonw");
    aria2Process?.kill();
  }
}
