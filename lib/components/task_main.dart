import 'package:flutter/material.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/utils/common.dart';
import 'package:fotrix/components/task_item.dart';
import 'package:fotrix/models/page_info.dart';
import 'package:fotrix/models/task_list.dart';
import 'package:signals/signals_flutter.dart';

class TaskMain extends StatelessWidget {
  TaskMain({
    super.key,
    required this.data,
    required this.resume,
    required this.stop,
  });
  final PageInfo data;
  final dynamic Function() resume;
  final dynamic Function() stop;

  late final title = computed(
    () =>
        data.sideItem[pageInfo.pInd.value].subItems[pageInfo.mInd.value].title,
  );

  late final list = computed(
    () => [
      taskList.active,
      taskList.waiting,
      taskList.paused,
      taskList.complete,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return _buildMain([
      buildMainTitle(title.watch(context)),
      Row(
        children: [
          IconButton(
            onPressed: () => resume,
            icon: Icon(Icons.play_arrow),
            color: ColorTheme.textColor.value,
          ),
          IconButton(
            onPressed: () => stop,
            icon: Icon(Icons.pause),
            color: ColorTheme.textColor.value,
          ),
        ],
      ),
    ], _buildList());
  }

  Widget _buildMain(List<Widget> children, Widget child) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
        buildDivider(),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildList() {
    return Watch(
      (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: list.value[pageInfo.mInd.value].length,
        itemBuilder: (context, index) {
          return TaskItem(task: list.value[pageInfo.mInd.value][index]);
        },
      ),
    );
  }
}
