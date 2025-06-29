import "dart:io";
import "package:flutter/material.dart";
import "package:fotrix/utils/common.dart";
import "package:fotrix/models/config.dart";
import "package:fotrix/models/task.dart";
import "package:fotrix/models/task_list.dart";
import "package:signals/signals_flutter.dart";

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: buildTaskCard(
          ListTile(
            leading: IconButton(
              color: ColorTheme.textColor.value,
              icon: _buildDownloadButton(task),
              onPressed: () {
                if (task.status.value == TaskStatus.active) {
                  taskList.stopTask(task);
                } else if (task.status.value == TaskStatus.waiting) {
                } else if (task.status.value == TaskStatus.paused) {
                  taskList.resumeTask(task);
                } else {
                  final path = config.savePath.replaceAll("/", "\\");
                  Process.run("explorer", [path]);
                }
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText(task.name),
                buildText(task.progress.watch(context)),
              ],
            ),
            subtitle: _buildSizePart(task),
            trailing: IconButton(
              color: ColorTheme.textColor.value,
              onPressed: () {
                taskList.deleteTask(task);
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ),
      ),
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

  Widget _buildDownloadButton(Task task) {
    if (task.status.value == TaskStatus.active) {
      return Icon(Icons.file_download);
    } else if (task.status.value == TaskStatus.waiting) {
      return Icon(Icons.stop);
    } else if (task.status.value == TaskStatus.paused) {
      return Icon(Icons.stop);
    } else {
      return Icon(Icons.download_done);
    }
  }
}
