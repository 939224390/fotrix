import 'package:flutter/material.dart';
import 'package:fotrix/components/bar/page_side.dart';
import 'package:fotrix/components/main/task_main.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/utils/common.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (context, config, child) {
        return Row(
          children: [
            buildSideContainer(PageSide()),
            Expanded(child: buildMainContainer(TaskMain())),
          ],
        );
      },
    );
  }
}
