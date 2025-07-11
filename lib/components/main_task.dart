import 'package:flutter/material.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/utils/common.dart';
import 'package:fotrix/components/task_item.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:signals/signals_flutter.dart';

class MainTask extends StatelessWidget {
  MainTask({super.key, required this.data});
  final PageInfo data;

  late final title = computed(
    () => data.sideItem[pInf.pInd].subItems[pInf.mInd].title,
  );

  late final currList = computed(
    () => switch (pInf.mInd) {
      0 => taskList.active,
      1 => taskList.waiting,
      2 => taskList.paused,
      3 => taskList.complete,
      _ => [],
    },
  );

  @override
  Widget build(BuildContext context) {
    return _buildMain([
      buildMainTitle(title.watch(context)),
      _buildBtn(),
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

  Widget _buildBtn() {
    return Row(
      children: [
        IconButton(
          onPressed: () => {},
          icon: Icon(Icons.play_arrow),
          color: ColorTheme.textColor.value,
        ),
        IconButton(
          onPressed: () => {},
          icon: Icon(Icons.pause),
          color: ColorTheme.textColor.value,
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
