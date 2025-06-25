import "dart:convert";
import "dart:io";
import "package:fotrix/models/logger.dart";
import "package:fotrix/utils/cross.dart";
import "package:fotrix/models/config.dart";
import "package:fotrix/models/task_list.dart";
import "package:http/http.dart" as http;

class Aria2Client {
  final String host;
  final int port;
  final String? secret;

  Process? aria2Process;
  Aria2Client({this.host = 'localhost', this.port = 16800, this.secret});

  String get _baseUrl => 'http://$host:$port/jsonrpc';

  //启动aria2服务
  start() async {
    if (!await Cross().isAria2Running()) {
      runLog.log("Aria2服务未启动，正在启动");
      await _startAria2();
    } else if (!await checkConnection()) {
      await runLog.log("Aria2连接失败，正在重启");
      await _startAria2();
    }
    await runLog.log("Aria2服务已启动");

    await taskList.start();
  }

  //发送请求
  Future<dynamic> _sendRequest(
    String method, [
    List<dynamic> params = const [],
  ]) async {
    if (secret != null) {
      params = ['token:$secret', ...params];
    }

    final requestBody = jsonEncode({
      'jsonrpc': '2.0',
      'method': method,
      'params': params,
      'id': 'flutter_aria2_client',
    });
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('error')) {
          throw Exception('Aria2 error: ${jsonResponse['error']['message']}');
        }
        final result = jsonResponse['result'];

        return result;
      } else {
        await runLog.log("Aria2请求失败: ${response.body}");
        return -1;
      }
    } catch (e) {
      await runLog.log("Aria2请求失败: $e");
      return -1;
    }
  }

  Future<String> getAria2Version() async {
    final v = await _sendRequest('aria2.getVersion');
    return v["version"];
  }

  //检查连接状态
  Future<bool> checkConnection() async {
    try {
      if (await _sendRequest('aria2.getVersion') != -1) {
        return true;
      }
      return false;
    } catch (e) {
      await runLog.log("Aria2连接失败: $e");
      return false;
    }
  }

  //添加任务
  Future<String> addTask(String url) async {
    return await _sendRequest('aria2.addUri', [
      [url],
    ]);
  }

  //获取下载列表
  Future<List<dynamic>> tellActive() async {
    return await _sendRequest('aria2.tellActive');
  }

  //获取等待列表
  Future<List<dynamic>> tellWaiting(int start, int num) async {
    return await _sendRequest('aria2.tellWaiting', [start, num]);
  }

  // 获取下载状态
  Future<Map<String, dynamic>> tellStatus(String gid) async {
    return await _sendRequest('aria2.tellStatus', [gid]);
  }

  // 暂停任务
  Future<String> pauseTask(String gid) async {
    return await _sendRequest('aria2.pause', [gid]);
  }

  //暂停全部任务
  Future<String> pauseAll() async {
    return await _sendRequest('aria2.pauseAll');
  }

  //继续任务
  Future<String> resumeTask(String gid) async {
    return await _sendRequest('aria2.unpause', [gid]);
  }

  //继续全部任务
  Future<String> resumeAll() async {
    return await _sendRequest('aria2.unpauseAll');
  }

  //删除任务
  Future<String> removeTask(String gid) async {
    return await _sendRequest('aria2.remove', [gid]);
  }

  //启动aria2
  _startAria2() async {
    try {
      await Cross().createAria2();

      // 获取应用目录
      final aria2Path = await Cross().getAria2Path();
      final aria2ConfPath = await Cross().getAria2ConfPath();

      // 启动 Aria2 进程
      aria2Process = await Process.start(aria2Path, [
        '--dir=${config.savePath}',
        '--max-concurrent-downloads=${config.maxDown}',
        '--max-connection-per-server=${config.threadCount}',
        '--conf-path=$aria2ConfPath',
        '--rpc-listen-port=16800',
        '--enable-rpc',
        '--rpc-listen-all=true',
        '--rpc-allow-origin-all',
        '--save-session-interval=60',
        '--continue=true',
      ]);
      await runLog.log("Aria2服务启动成功");
    } catch (e) {
      runLog.log("Aria2服务启动失败 $e");
    }
  }

  //关闭aria2服务
  shutdownAria2() async {
    aria2Process?.kill();
  }
}

Aria2Client aria2Client = Aria2Client();
