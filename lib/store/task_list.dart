import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fotrix/utils/logger.dart';
import 'package:signals/signals.dart';
import 'task.dart';
import "package:fotrix/api/aria2_api.dart";

class TaskList {
  //任务队列
  final Signal<List<Task>> _active = Signal([]);
  final Signal<List<Task>> _complete = Signal([]);
  final Signal<List<Task>> _waiting = Signal([]);

  List<Task> get active => _active.value;
  List<Task> get complete => _complete.value;
  List<Task> get waiting => _waiting.value;

  //初始化任务
  Future<Task> createTask(dynamic status, TaskStatus taskStatus) async {
    final task = await _initialTask(
      status['files'][0]['uris'][0]['uri'],
      status['gid'],
      status['files'][0]['path'],
      taskStatus,
    );
    return task;
  }

  //创建任务
  Future<bool> addTask(String url) async {
    final list = [...active, ...complete, ...waiting];

    bool isExist = list.any((element) {
      if (element.url == url) {
        if (element.status.value == TaskStatus.complete ||
            element.status.value == TaskStatus.error) {
          return false;
        } else {
          return true;
        }
      }
      return false;
    });

    //向aria2提交下载任务，并检查等待队列
    if (!isExist) {
      await aria2Api.addTask(url);
    }
    return true;
  }

  //更新下载列表
  Future<bool> checkActive(List list) async {
    bool addList = false;
    for (var item in list) {
      final gid = item['gid'];
      if (![...active, ...waiting].any((ele) => ele.gid == gid)) {
        final taskDetail = await aria2Api.tellStatus(gid);
        final task = await createTask(taskDetail, TaskStatus.active);
        addList = true;
        _active.value = add(active, task);
        checkTaskStatus(task);
      } else if ([...waiting].any((ele) => ele.gid == gid)) {
        final task = waiting.firstWhere((element) => element.gid == gid);
        setTaskStatus(task, TaskStatus.active);
        checkTaskStatus(task);
      }
    }
    return addList;
  }

  //更新等待列表
  Future<void> checkWaiting(List unActice) async {
    if (unActice.isNotEmpty) {
      for (var un in unActice) {
        final gid = un['gid'];
        if (!waiting.any((element) => element.gid == gid)) {
          if (un['status'] == 'waiting') {
            final task = await createTask(un, TaskStatus.waiting);
            waiting.add(task);
          } else if (un['status'] == 'paused') {
            final task = await createTask(un, TaskStatus.paused);
            waiting.add(task);
          }
        }
      }
    }
  }

  //更新任务状态
  Future<void> updateTaskStatus(Task task) async {
    final status = await aria2Api.tellStatus(task.gid);
    task.completedLength.value = int.parse(status['completedLength'] ?? 0);
    task.totalLength.value = int.parse(status['totalLength'] ?? 0);
    task.downloadSpeed.value = double.parse(status['downloadSpeed'] ?? 0);
    if (status['status'] == 'complete') {
      completeTask(task);
    } else if (status['status'] == 'error') {
      setTaskStatus(task, TaskStatus.error);
    }
  }

  //监听任务状态
  void checkTaskStatus(Task task) async {
    Timer.periodic(Duration(seconds: 1), (time) async {
      switch (task.status.value) {
        case TaskStatus.active:
          updateTaskStatus(task);
          break;
        case _:
          time.cancel();
          break;
      }
    });
  }

  //获取任务列表任务数量
  List<int> getTaskNum() {
    final list = [active.length, waiting.length, complete.length];
    return list;
  }

  // 暂停任务
  void stopTask(Task task) async {
    setTaskStatus(task, TaskStatus.paused);

    await aria2Api.pauseTask(task.gid);
    await updateTaskStatus(task);
  }

  //暂停所有任务
  void stopAll() async {
    await aria2Api.pauseAll();
    for (var task in active) {
      setTaskStatus(task, TaskStatus.paused);
      await updateTaskStatus(task);
    }
  }

  //继续任务
  void resumeTask(Task task) async {
    setTaskStatus(task, TaskStatus.waiting);

    await aria2Api.resumeTask(task.gid);
  }

  //继续所有任务
  void resumeAll() async {
    await aria2Api.resumeAll();
    final copyPaused = List<Task>.from(waiting);

    for (var task in copyPaused) {
      setTaskStatus(task, TaskStatus.waiting);
    }
  }

  //重试任务
  void retryTask(Task task) async {
    await deleteTask(task);
    await Future.delayed(Duration(milliseconds: 500));
    await addTask(task.url);
  }

  //任务完成
  void completeTask(Task task) {
    setTaskStatus(task, TaskStatus.complete);
  }

  //删除任务
  Future<void> deleteTask(Task task) async {
    await updateTaskStatus(task);
    if (task.status.value != TaskStatus.complete) {
      await aria2Api.removeTask(task.gid);
    }
    setTaskStatus(task, TaskStatus.remove);

    await Future.delayed(Duration(milliseconds: 500));

    if (await File(task.tmpPath).exists()) {
      File(task.tmpPath).delete();
    }
    if (await File(task.savePath).exists()) {
      File(task.savePath).delete();
    }
  }

  void setTaskStatus(Task task, TaskStatus taskStatus) async {
    switch (taskStatus) {
      case TaskStatus.waiting:
        task.status.value = TaskStatus.waiting;
        _active.value = remove(active, task);

        break;
      case TaskStatus.active:
        task.status.value = TaskStatus.active;
        _active.value = add(active, task);
        _waiting.value = remove(waiting, task);
        break;
      case TaskStatus.paused:
        task.status.value = TaskStatus.paused;
        _active.value = remove(active, task);
        _waiting.value = add(waiting, task);
        break;
      case TaskStatus.complete:
        task.status.value = TaskStatus.complete;
        _active.value = remove(active, task);
        _waiting.value = remove(waiting, task);
        _complete.value = add(complete, task);
        break;
      case TaskStatus.remove:
        task.status.value = TaskStatus.remove;
        _active.value = remove(active, task);
        _waiting.value = remove(waiting, task);
        _complete.value = remove(complete, task);
        break;
      case TaskStatus.error:
        task.status.value = TaskStatus.error;
        _active.value = remove(active, task);
        _waiting.value = add(waiting, task);
        break;
    }
  }

  List<Task> remove(List<Task> list, Task task) {
    return list.where((t) => t != task).toList();
  }

  List<Task> add(List<Task> list, Task task) {
    return list = [...list, task];
  }

  //初始化任务
  Future<Task> _initialTask(
    String url,
    String gid,
    String sPath,
    TaskStatus taskStatus,
  ) async {
    final status = await aria2Api.tellStatus(gid);
    final fileName = _getFileName(status);
    final savePath = sPath;
    final completedLength = int.parse(status['completedLength'] ?? 0);
    final totalLength = int.parse(status['totalLength'] ?? 0);
    final downloadSpeed = double.parse(status['downloadSpeed'] ?? 0);

    final task = Task(
      gid: gid,
      url: url,
      name: fileName,
      savePath: savePath,
      completedLength: Signal(completedLength),
      totalLength: Signal(totalLength),
      downloadSpeed: Signal(downloadSpeed),
      status: Signal(taskStatus),
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
