import 'package:flutter/material.dart';
import 'package:fotrix/components/common.dart';
import 'package:fotrix/components/taskitem/task_item.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:fotrix/utils/theme.dart';
import 'package:signals/signals_flutter.dart';

class MainTask extends StatelessWidget {
  MainTask({super.key, required this.data, required this.index});
  final PageInfo data;
  final int index;

  late final title = computed(
    () => data.tabs[data.tabIndex].tabItems[data.mainIndex].title,
  );

  late final currList = computed(
    () => switch (index) {
      0 => taskList.totalList,
      1 => taskList.active,
      2 => taskList.waiting,
      3 => taskList.complete,
      _ => [],
    },
  );

  @override
  Widget build(BuildContext context) {
    return _buildMain([
      buildMainTitle(title.watch(context), context),
      _buildBtn(context),
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

  Widget _buildBtn(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => {},
          icon: Icon(Icons.play_arrow),
          color: context.textColor,
        ),
        IconButton(
          onPressed: () => {},
          icon: Icon(Icons.pause),
          color: context.textColor,
        ),
      ],
    );
  }

  Widget _buildList() {
    return Watch(
      (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: currList.value.length,
        itemBuilder: (context, index) {
          return TaskItem(task: currList.value[index]);
        },
      ),
    );
  }
}
