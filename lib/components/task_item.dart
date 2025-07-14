import "package:flutter/material.dart";
import "package:fotrix/utils/common.dart";
import "package:fotrix/store/config.dart";
import "package:fotrix/store/task.dart";
import "package:fotrix/store/task_list.dart";
import "package:signals/signals_flutter.dart";

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) => _buildTaskItem(
        _buildItemDetail(
          _buildOpButton(task),
          _buildTaskTitle(),
          _buildSizePart(task),
          _buildDeleteButton(),
        ),
      ),
    );
  }

  Widget _buildTaskItem(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Card(color: ColorTheme.cardColor.value, child: child),
    );
  }

  Widget _buildItemDetail(
    Widget leading,
    Widget title,
    Widget subtitle,
    Widget trailing,
  ) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    );
  }

  Widget _buildOpButton(Task task) {
    IconData icon;
    switch (task.status.value) {
      case TaskStatus.active:
        icon = Icons.file_download;
        break;
      case TaskStatus.waiting:
        icon = Icons.stop;
        break;
      case TaskStatus.paused:
        icon = Icons.stop;
        break;
      case TaskStatus.complete:
        icon = Icons.download_done;
        break;
      case _:
        icon = Icons.download_done;
    }

    return IconButton(
      color: ColorTheme.textColor.value,
      icon: Icon(icon),
      onPressed: () async {
        if (task.status.value == TaskStatus.active) {
          taskList.stopTask(task);
        } else if (task.status.value == TaskStatus.waiting) {
        } else if (task.status.value == TaskStatus.paused) {
          taskList.resumeTask(task);
        } else {
          print(task.savePath);
        }
      },
    );
  }

  Widget _buildTaskTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [buildText(task.name), buildText(task.progress.value)],
    );
  }

  Widget _buildSizePart(Task task) {
    if (task.status.value == TaskStatus.active) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildText(' ${(task.dlSize.value)}/${task.totalSize.value}'),
          buildText(
            '速度: ${task.formattedSpeed.value} - 剩余: ${task.remainTime.value}',
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildText(' ${(task.dlSize.value)}/${task.totalSize.value}'),
        ],
      );
    }
  }

  Widget _buildDeleteButton() {
    return IconButton(
      color: ColorTheme.textColor.value,
      onPressed: () {
        taskList.deleteTask(task);
      },
      icon: Icon(Icons.delete),
    );
  }
}
