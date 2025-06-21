import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fotrix/models/config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';

class Cross {
  //获取配置路径
  Future<String> getDocPath() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return '${appDocDir.path}/fotrix';
  }

  //创建配置文件件
  createConfig() async {
    final dir = Directory(await getDocPath());
    final file = File('${await getDocPath()}/config.json');
    if (!await dir.exists()) {
      dir.create();
    }
    if (!await file.exists()) {
      file.create();
      await config.saveConfig();
    }
  }

  //获取aria2
  Future<ByteData> getAria2() async {
    if (Platform.isWindows) {
      return await rootBundle.load('assets/aria2/win/aria2c.exe');
    } else if (Platform.isMacOS) {
      return await rootBundle.load('assets/aria2/mac/aria2c');
    } else {
      return await rootBundle.load('assets/aria2/linux/aria2c');
    }
  }

  //获取aria2配置文件
  Future<ByteData> getAria2Conf() async {
    if (Platform.isWindows) {
      return await rootBundle.load('assets/aria2/win/aria2.conf');
    } else if (Platform.isMacOS) {
      return await rootBundle.load('assets/aria2/mac/aria2.conf');
    } else {
      return await rootBundle.load('assets/aria2/linux/aria2.conf');
    }
  }

  //获取aria2路径
  Future<String> getAria2Path() async {
    if (Platform.isWindows) {
      return '${await getDocPath()}/aria2/aria2c.exe';
    }
    return '${await getDocPath()}/aria2/ariac';
  }

  //获取aria2配置文件
  Future<String> getAria2ConfPath() async {
    return '${await getDocPath()}/aria2/aria2.conf';
  }

  //创建aria2
  createAria2() async {
    final aria2 = File(await getAria2Path());
    final aria2Conf = File(await getAria2ConfPath());
    if (!(await aria2.exists() && await aria2Conf.exists())) {
      final dir = Directory('${await getDocPath()}/aria2');
      if (!await dir.exists()) {
        await dir.create();
      }

      await aria2.create();
      await aria2Conf.create();
      //将aria2从asset复制出来
      ByteData aria2Data = await Cross().getAria2();
      ByteData aria2ConfData = await Cross().getAria2Conf();
      final aria2Bytes = aria2Data.buffer.asUint8List();
      final aria2ConfBytes = aria2ConfData.buffer.asUint8List();
      await aria2.writeAsBytes(aria2Bytes);
      await aria2Conf.writeAsBytes(aria2ConfBytes);

      // 给可执行文件添加执行权限
      if (Platform.isLinux || Platform.isMacOS) {
        await Shell().run('chmod +x ${await getAria2Path()}');
      }
    }
  }

  /// 检查 aria2c 进程是否在运行
  Future<bool> isAria2Running() async {
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
      return false;
    }
  }
}
