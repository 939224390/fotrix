import "dart:convert";
import "dart:io";
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
      throw Exception('Failed to send request: ${response.body}');
    }
  }

  //检查连接状态
  Future<bool> checkConnection() async {
    try {
      final v = await _sendRequest('aria2.getVersion');
      config.aria2Version = v["version"];
      return true;
    } catch (e) {
      return false;
    }
  }

  //启动aria2服务
  start() async {
    while (true) {
      if (!await Cross().isAria2Running()) {
        _startAria2();
      }
      final isConnected = await checkConnection();
      if (isConnected) {
        config.aria2Connected = true;
        await taskList.start();
        return;
      } else {
        config.aria2Connected = false;
      }
      await Future.delayed(Duration(seconds: 5));
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

  //获取暂停列表
  Future<List<dynamic>> tellPaused(int start, int num) async {
    return await _sendRequest('aria2.tellStopped', [start, num]);
  }

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
  void _startAria2() async {
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
  }

  //关闭aria2服务
  void shutdownAria2() {
    aria2Process?.kill();
  }
}

Aria2Client aria2Client = Aria2Client();
