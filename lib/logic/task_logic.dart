import 'dart:io';

import 'package:fotrix/store/task.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:open_file/open_file.dart';

class TaskLogic {
  //状态按钮逻辑
  void sBtnLogic(Task task) {
    switch (task.status.value) {
      case TaskStatus.active:
        taskList.stopTask(task);
        break;
      case TaskStatus.paused:
        taskList.resumeTask(task);
        break;
      case TaskStatus.complete:
        Process.run("explorer", [
          "/select,${task.savePath.replaceAll("/", "\\")}",
        ]);
        break;
      case _:
        break;
    }
  }

  //item长按逻辑
  void itemLogic(Task task) {
    switch (task.status.value) {
      case TaskStatus.complete:
        OpenFile.open(task.savePath.replaceAll("/", "\\"));
        break;
      case _:
        break;
    }
  }

  void delBtn(Task task) {
    taskList.deleteTask(task);
  }
}
