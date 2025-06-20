import "dart:io";
import "package:flutter/material.dart";
import "package:fotrix/components/common/common.dart";
import "package:fotrix/models/config.dart";
import "package:fotrix/models/task.dart";
import "package:fotrix/models/task_list.dart";
import "package:provider/provider.dart";

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Consumer2<Config,TaskList>(
      builder: (context,config, taskList, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Card(
            color: config.getColor('card'),
            child: ListTile(
              leading: IconButton(
                icon: _buildDownloadButton(task),
                onPressed: () {
                  if (task.status == TaskStatus.downloading) {
                    taskList.stopTask(task);
                  } else if (task.status == TaskStatus.paused) {
                    taskList.resumeTask(task);
                  } else {
                    final path = config.savePath.replaceAll("/", "\\");
                    Process.run("explorer", [path]);
                  }
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [buildText(task.name), buildText(task.progress)],
              ),
              subtitle: _buildSizePart(task),
              trailing: IconButton(
                onPressed: () {
                  taskList.deleteTask(task);
                },
                icon: Icon(Icons.delete),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSizePart(Task task) {
    if (task.status == TaskStatus.downloading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildText(' ${(task.dlSize)}/${task.totalSize}'),
          buildText('速度: ${task.formattedSpeed} - 剩余: ${task.remainTime}'),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [buildText(' ${(task.dlSize)}/${task.totalSize}')],
      );
    }
  }

  Widget _buildDownloadButton(Task task) {
    if (task.status == TaskStatus.downloading) {
      return Icon(Icons.file_download);
    } else if (task.status == TaskStatus.paused) {
      return Icon(Icons.stop);
    } else {
      return Icon(Icons.download_done);
    }
  }
}
