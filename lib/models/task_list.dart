import 'dart:convert';
import 'dart:io';

import 'package:fotrix/models/aria2_client.dart';
import 'package:fotrix/models/config.dart';
import 'task.dart';
import 'package:flutter/material.dart';

class TaskList with ChangeNotifier {
  final List<Task> _downloading = [];
  final List<Task> _paused = [];
  final List<Task> _completed = [];

  List<Task> get downloading => _downloading;
  List<Task> get paused => _paused;
  List<Task> get completed => _completed;

  final a2c = aria2Client;

  //创建任务
  void createTask(String url) async {
    if ([
      ...downloading,
      ...paused,
      ...completed,
    ].any((element) => element.url == url)) {
      debugPrint("任务已存在");
      return;
    }
    final gid = await a2c.addTask(url);

    final task = await _initialTask(url, gid);

    downloading.add(task);
    checkTaskStatus();
    refesh();
  }

  //检查下载列表
  void checkDlList() async {
    final dlList = await a2c.tellActive();
    for (var dl in dlList) {
      final gid = dl['gid'];
      if (!downloading.any((element) => element.gid == gid)) {
        final task = await _initialTask(dl['files'][0]['uris'][0]['uri'], gid);
        downloading.add(task);
        checkTaskStatus();
      }
    }
    await Future.delayed(Duration(seconds: 1));
    checkDlList();
    refesh();
  }

  //检查暂停列表
  void checkStopList() async {}

  //监听任务状态
  void checkTaskStatus() async {
    final taskCopy = List<Task>.from(downloading);
    if (downloading.isNotEmpty) {
      for (var task in taskCopy) {
        if (task.status == TaskStatus.downloading) {
          final status = await a2c.tellStatus(task.gid);
          task.completedLength = int.parse(status['completedLength'] ?? 0);
          task.totalLength = int.parse(status['totalLength'] ?? 0);
          task.downloadSpeed = double.parse(status['downloadSpeed'] ?? 0);
          refesh();
          if (task.completedLength == task.totalLength) {
            completeTask(task);
          }
        }
      }
      await Future.delayed(Duration(seconds: 1));
      checkTaskStatus();
    }
    return;
  }

  // 暂停任务
  void stopTask(Task task) async {
    task.status = TaskStatus.paused;
    await a2c.pauseTask(task.gid);
    paused.add(task);
    refesh();
  }

  //暂停所有任务
  void stopAll() async {
    await a2c.pauseAll();
    for (var task in downloading) {
      task.status = TaskStatus.paused;
      paused.add(task);
    }

    refesh();
  }

  //继续任务
  void resumeTask(Task task) async {
    task.status = TaskStatus.downloading;
    await a2c.resumeTask(task.gid);
    paused.remove(task);
    refesh();
  }

  //继续所有任务
  void resumeAll() async {
    await a2c.resumeAll();
    final copyPaused = List<Task>.from(paused);

    for (var task in copyPaused) {
      task.status = TaskStatus.downloading;
      downloading.add(task);
      paused.remove(task);
    }

    refesh();
  }

  //任务完成
  void completeTask(Task task) {
    task.status = TaskStatus.completed;

    downloading.remove(task);
    paused.remove(task);
    completed.add(task);
    refesh();
  }

  //删除任务(*无法删除aria2文件)
  void deleteTask(Task task) async {
    await a2c.removeTask(task.gid);
    downloading.remove(task);
    paused.remove(task);
    completed.remove(task);
    if (await File(task.tmpPath).exists()) File(task.tmpPath).delete();
    if (await File(task.savePath).exists()) File(task.savePath).delete();

    refesh();
  }

  void refesh() {
    notifyListeners();
  }

  //初始化任务
  Future<Task> _initialTask(String url, String gid) async {
    final status = await a2c.tellStatus(gid);
    final fileName = _getFileName(status);
    final savePath = "${config.savePath}/$fileName";
    final completedLength = int.parse(status['completedLength'] ?? 0);
    final totalLength = int.parse(status['totalLength'] ?? 0);
    final downloadSpeed = double.parse(status['downloadSpeed'] ?? 0);

    final task = Task(
      gid: gid,
      url: url,
      name: fileName,
      savePath: savePath,
      completedLength: completedLength,
      totalLength: totalLength,
      downloadSpeed: downloadSpeed,
      status: TaskStatus.downloading,
    );
    return task;
  }
}

TaskList taskList = TaskList();

//获取文件名
String _getFileName(Map<String, dynamic> status) {
  final tmpPath = status['files'][0]['path'];
  final String rawName;
  if (tmpPath != "") {
    rawName = tmpPath.split('/').last as String;
  } else {
    rawName = status['files'][0]['uris'][0]['uri'].split('/').last as String;
  }
  try {
    final dName = utf8.decode(rawName.runes.toList());
    return dName;
  } catch (e) {
    return rawName;
  }
}
