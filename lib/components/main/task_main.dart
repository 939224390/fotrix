import 'package:flutter/material.dart';
import 'package:fotrix/utils/common.dart';
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
                  buildMainTitle(
                    pageInfo.sideBtn[pageInfo.pInd][pageInfo.mInd],
                  ),
                  Row(
                    children: [
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

  Widget _buildList() {
    final list = [
      taskList.active,
      taskList.waiting,
      taskList.paused,
      taskList.complete,
    ];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list[pageInfo.mInd].length,
      itemBuilder: (context, index) {
        return TaskItem(task: list[pageInfo.mInd][index]);
      },
    );
  }
}
