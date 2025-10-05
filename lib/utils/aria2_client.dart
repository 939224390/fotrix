import "dart:async";
import "dart:convert";
import "dart:io";
import "package:fotrix/utils/logger.dart";
import "package:fotrix/types/types.dart";
import "package:fotrix/utils/cross.dart";
import "package:fotrix/store/config.dart";
import "package:web_socket_channel/io.dart";
import "package:json_rpc_2/json_rpc_2.dart";

class Aria2Client {
  final String wsUrl = "ws://localhost:16800/jsonrpc";
  IOWebSocketChannel? wsChannel;
  Client? client;
  Process? aria2Process;

  void connect() {
    wsChannel = IOWebSocketChannel.connect(wsUrl);
    client = Client(wsChannel!.cast<String>());
    unawaited(client?.listen());
  }

  Future<void> start() async {
    try {
      final isRunning = await Cross().isAria2Running();
      logger.info("正在启动Aria2服务...");
      if (!isRunning) {
        await _startAria2();
      }
      logger.info('aria2已启动');
      connect();
      logger.info("已连接Aria2服务");
    } catch (e) {
      logger.info("正在启动Aria2服务...");
      await _startAria2();
      logger.info('aria2已启动');
      connect();
      logger.info("已连接Aria2服务");
    }
  }

  Future<Response> send(String method, [List<dynamic>? params]) async {
    try {
      final response = await client?.sendRequest(method, params);
      if (response == null) {
        return Response(-1, "请求失败");
      }
      return Response(1, response);
    } catch (e) {
      return Response(-1, "请求失败:$e");
    }
  }

  Future<void> writeConf() async {
    try {
      final aria2ConfPath = await Cross().getAria2ConfPath();
      //   final aria2LogPath = await Cross().getAria2LogPath();
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
      //confContent.write("log=$aria2LogPath\n");
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

  void shutdown() {
    aria2Process?.kill();
  }
}

final a2c = Aria2Client();
