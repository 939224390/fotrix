import "package:flutter/material.dart";
import "package:fotrix/logic/task_logic.dart";
import "package:fotrix/utils/color_mode.dart";
import "package:fotrix/utils/common.dart";
import "package:fotrix/store/task.dart";
import "package:signals/signals_flutter.dart";

class TaskItem extends StatelessWidget {
  TaskItem({super.key, required this.task});
  final Task task;
  final TaskLogic taskLogic = TaskLogic();

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
      onLongPress: () => taskLogic.itemLogic(task),
    );
  }

  Widget _buildOpButton(Task task) {
    return IconButton(
      color: ColorTheme.textColor.value,
      icon: task.taskIcon.value,
      onPressed: () => taskLogic.sBtnLogic(task),
    );
  }

  Widget _buildTaskTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: buildText(task.name)),
        buildText(task.progress.value),
      ],
    );
  }

  Widget _buildSizePart(Task task) {
    if (task.status.value == TaskStatus.active) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildText(task.sizeRate.value),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: buildText(task.speedTime.value),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [buildText(task.sizeRate.value)],
      );
    }
  }

  Widget _buildDeleteButton() {
    return IconButton(
      color: ColorTheme.textColor.value,
      onPressed: () => taskLogic.delBtn(task),
      icon: Icon(Icons.delete),
    );
  }
}
