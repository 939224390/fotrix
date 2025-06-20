import 'package:flutter/material.dart';
import 'package:fotrix/components/common/common.dart';
import 'package:fotrix/components/main/task_item.dart';
import 'package:fotrix/models/page_info.dart';
import 'package:fotrix/models/task_list.dart';
import 'package:provider/provider.dart';

class TaskMain extends StatelessWidget {
  const TaskMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageInfo, TaskList>(
      builder: (context, pageInfo, taskList, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTitle(pageInfo.mInd),

                  // Need to Edit
                  Row(
                    children: [
                      Icon(Icons.restart_alt),
                      IconButton(
                        onPressed: () => taskList.resumeAll(),
                        icon: Icon(Icons.play_arrow),
                      ),
                      IconButton(
                        onPressed: () => taskList.stopAll(),
                        icon: Icon(Icons.pause),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            buildDivider(),
            Expanded(child: _buildList()),
          ],
        );
      },
    );
  }

  Widget _buildTitle(int index) {
    List title = ["下载中", "已暂停", "已完成"];
    return buildTitle(title[index]);
  }

  Widget _buildList() {
    final list = [taskList.downloading, taskList.paused, taskList.completed];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list[pageInfo.mInd].length,
      itemBuilder: (context, index) {
        return TaskItem(task: list[pageInfo.mInd][index]);
      },
    );
  }
}
