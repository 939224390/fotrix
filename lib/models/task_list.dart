import 'dart:convert';
import 'dart:io';
import 'package:fotrix/models/aria2_client.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/models/logger.dart';
import 'task.dart';
import 'package:flutter/material.dart';

class TaskList with ChangeNotifier {
  //任务队列
  final List<Task> _active = [];
  final List<Task> _paused = [];
  final List<Task> _complete = [];
  final List<Task> _waiting = [];

  List<Task> get active => _active;
  List<Task> get paused => _paused;
  List<Task> get complete => _complete;
  List<Task> get waiting => _waiting;

  final a2c = aria2Client;

  start() async {
    config.aria2Connected = await a2c.checkConnection();
    await runLog.log("Aria2连接状态: ${config.aria2Connected}");

    await checkActive();
    await checkWaiting();
    refesh();
    await Future.delayed(Duration(seconds: 2));
    start();
  }

  //创建任务
  Future<bool> createTask(String url) async {
    final list = [...active, ...paused, ...complete, ...waiting];
    if (list.any((element) => element.url == url)) {
      return false;
    }

    //创建任务后加入等待队列
    final gid = await a2c.addTask(url);
    final task = await _initialTask(url, gid, TaskStatus.waiting);

    _waiting.add(task);

    await checkWaiting();

    refesh();

    return true;
  }

  //更新下载列表
  checkActive() async {
    final dlList = await a2c.tellActive();
    if (dlList.isNotEmpty) {
      for (var dl in dlList) {
        final gid = dl['gid'];
        if (!active.any((element) => element.gid == gid)) {
          final task = await _initialTask(
            dl['files'][0]['uris'][0]['uri'],
            gid,
            TaskStatus.active,
          );
          active.add(task);
          checkTaskStatus(task);
        }
      }
    }

    // refesh();
  }

  //更新等待列表
  checkWaiting() async {
    final unActice = await a2c.tellWaiting(0, 100);
    if (unActice.isNotEmpty) {
      for (var un in unActice) {
        final gid = un['gid'];
        if (!waiting.any((element) => element.gid == gid)) {
          if (un['status'] == 'waiting') {
            final task = await _initialTask(
              un['files'][0]['uris'][0]['uri'],
              gid,
              TaskStatus.waiting,
            );
            waiting.add(task);
          }
        }
      }
    }
    final wList = List<Task>.from(waiting);
    for (var task in wList) {
      if (!active.any((element) => element.gid == task.gid)) {
        setTaskStatus(task, TaskStatus.active);
        waiting.remove(task);
      }
    }
    // refesh();
  }

  //监听任务状态
  void checkTaskStatus(Task task) async {
    if (task.status == TaskStatus.active) {
      final status = await a2c.tellStatus(task.gid);
      task.completedLength = int.parse(status['completedLength'] ?? 0);
      task.totalLength = int.parse(status['totalLength'] ?? 0);
      task.downloadSpeed = double.parse(status['downloadSpeed'] ?? 0);
      refesh();
      if (task.completedLength == task.totalLength) {
        completeTask(task);
        refesh();
        return;
      }
      await Future.delayed(Duration(seconds: 1));
      checkTaskStatus(task);
    }
  }

  List<int> getTaskNum() {
    final list = [
      active.length,
      waiting.length,
      paused.length,
      complete.length,
    ];
    return list;
  }

  // 暂停任务
  void stopTask(Task task) async {
    setTaskStatus(task, TaskStatus.paused);

    await a2c.pauseTask(task.gid);

    refesh();
  }

  //暂停所有任务
  void stopAll() async {
    await a2c.pauseAll();
    for (var task in active) {
      setTaskStatus(task, TaskStatus.paused);
    }

    refesh();
  }

  //继续任务
  void resumeTask(Task task) async {
    setTaskStatus(task, TaskStatus.waiting);

    await a2c.resumeTask(task.gid);

    refesh();
  }

  //继续所有任务
  void resumeAll() async {
    await a2c.resumeAll();
    final copyPaused = List<Task>.from(paused);

    for (var task in copyPaused) {
      setTaskStatus(task, TaskStatus.waiting);
    }

    refesh();
  }

  //任务完成
  void completeTask(Task task) {
    setTaskStatus(task, TaskStatus.complete);

    refesh();
  }

  //删除任务
  void deleteTask(Task task) async {
    if (task.status != TaskStatus.complete) {
      await a2c.removeTask(task.gid);
    }
    setTaskStatus(task, TaskStatus.remove);

    if (await File(task.tmpPath).exists()) File(task.tmpPath).delete();
    if (await File(task.savePath).exists()) File(task.savePath).delete();

    refesh();
  }

  void refesh() {
    notifyListeners();
  }

  void setTaskStatus(Task task, TaskStatus taskStatus) {
    switch (taskStatus) {
      case TaskStatus.waiting:
        task.status = TaskStatus.waiting;
        active.remove(task);
        paused.remove(task);
        // waiting.add(task);
        break;
      case TaskStatus.active:
        task.status = TaskStatus.active;
        paused.remove(task);
        waiting.remove(task);
        // active.add(task);
        break;
      case TaskStatus.paused:
        task.status = TaskStatus.paused;
        active.remove(task);
        waiting.remove(task);
        paused.add(task);
        break;
      case TaskStatus.complete:
        task.status = TaskStatus.complete;
        active.remove(task);
        paused.remove(task);
        waiting.remove(task);
        complete.add(task);
        break;
      case TaskStatus.remove:
        task.status = TaskStatus.remove;
        active.remove(task);
        paused.remove(task);
        waiting.remove(task);
        complete.remove(task);
        break;
    }
  }

  //初始化任务
  Future<Task> _initialTask(
    String url,
    String gid,
    TaskStatus taskStatus,
  ) async {
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
      status: taskStatus,
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
