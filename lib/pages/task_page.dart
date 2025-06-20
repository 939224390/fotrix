import 'package:flutter/material.dart';
import 'package:fotrix/components/bar/page_side.dart';
import 'package:fotrix/components/main/task_main.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/components/window_control.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (context, config, child) {
        return Row(
          children: [
            Container(
              color: config.getColor("bar"),
              width: 200,
              child: Column(
                children: [
                  WindowControl(mode: "move"),
                  Expanded(child: PageSide()),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: config.getColor("main"),
                child: Column(
                  children: [
                    WindowControl(mode: "ctrl"),
                    Expanded(child: TaskMain()),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
