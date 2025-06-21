import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:fotrix/components/common/cross.dart";
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
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to send request: ${response.statusCode}');
    }
  }

  //检查连接状态
  Future<bool> checkConnection() async {
    try {
      await _sendRequest('aria2.getVersion');
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('连接检查失败: $e');
      }
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
        taskList.checkDlList();
        return;
      } else {
        if (kDebugMode) {
          print('连接失败');
        }
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
    // 获取应用文档目录
    final aria2Path = await Cross().getAria2Path();

    // 启动 Aria2 进程
    aria2Process = await Process.start(aria2Path, [
      '--rpc-listen-port=16800',
      '--enable-rpc',
      '--rpc-listen-all=true',
      '--rpc-allow-origin-all',
      '--save-session-interval=60',
      '--max-concurrent-downloads=10',
      '--continue=true',
    ]);
  }

  //关闭aria2服务
  void shutdownAria2() {
    aria2Process?.kill();
  }
}

Aria2Client aria2Client = Aria2Client();
