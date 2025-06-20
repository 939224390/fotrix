import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:fotrix/models/task_list.dart";
import "package:http/http.dart" as http;
import 'package:process_run/shell.dart';
import "package:path_provider/path_provider.dart";
import "package:process_run/process_run.dart";

class Aria2Client {
  final String host;
  final int port;
  final String? secret;

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
  void start() async {
    if (!await _isAria2Running()) {
      _startAria2();
    }
    final isConnected = await checkConnection();
    if (isConnected) {
      if (kDebugMode) {
        print('连接成功');
      }
      taskList.checkDlList();
    } else {
      if (kDebugMode) {
        print('连接失败');
      }
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
}

Aria2Client aria2Client = Aria2Client();

//启动aria2
void _startAria2() async {
  //   final savePath = config.savePath;
  // 获取应用文档目录
  final appDocDir = await getApplicationDocumentsDirectory();
  final aria2Path = '${appDocDir.path}/aria2/aria2c.exe';

  // 确保 Aria2 可执行文件存在
  if (!await File(aria2Path).exists()) {
    // 从 assets 复制 Aria2 可执行文件到应用目录
    await _copyAria2FromAssets(aria2Path);
  }

  // 给可执行文件添加执行权限
  if (Platform.isLinux || Platform.isMacOS) {
    await Shell().run('chmod +x $aria2Path');
  }

  // 启动 Aria2 进程
  await Process.start(aria2Path, [
    '--rpc-listen-port=16800',
    '--enable-rpc',
    '--rpc-listen-all=true',
    '--rpc-allow-origin-all',
    '--save-session-interval=60',
    '--max-concurrent-downloads=10',
    '--continue=true',
  ]);
}

/// 从 assets 复制 Aria2 可执行文件到应用目录
Future<void> _copyAria2FromAssets(String destinationPath) async {
  final data = await rootBundle.load('assets/aria2/aria2c.exe');
  final bytes = data.buffer.asUint8List();
  await File(destinationPath).writeAsBytes(bytes);
}

/// 检查 aria2c 进程是否在运行
Future<bool> _isAria2Running() async {
  try {
    late ProcessResult result;
    if (Platform.isWindows) {
      // Windows 系统使用 tasklist 命令
      result = await Process.run('tasklist', []);
      return result.stdout.toString().contains('aria2c.exe');
    } else if (Platform.isLinux || Platform.isMacOS) {
      // Linux 和 macOS 系统使用 ps 命令
      result = await Process.run('ps', ['-A']);
      return result.stdout.toString().contains('aria2c');
    } else {
      // 不支持的操作系统
      return false;
    }
  } catch (e) {
    debugPrint('检测 aria2c 进程时出错: $e');
    return false;
  }
}
