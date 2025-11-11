import "package:flutter/material.dart";
import "package:fotrix/logic/task_logic.dart";
import "package:fotrix/components/common.dart";
import "package:fotrix/store/task.dart";
import "package:fotrix/utils/theme.dart";
import "package:signals/signals_flutter.dart";

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.task});
  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TaskLogic taskLogic = TaskLogic();

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) => _taskCard(
        _stateBtn(widget.task),
        _taskTitleandProgress(),
        _dltlSize(widget.task),
        _delBtn(),
      ),
    );
  }

  Widget _taskCard(
    Widget leading,
    Widget title,
    Widget subtitle,
    Widget trailing,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Card(
        color: context.cardColor,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onLongPress: () => taskLogic.itemLogic(widget.task),
        ),
      ),
    );
  }

  Widget _stateBtn(Task task) {
    return IconButton(
      color: context.textColor,
      icon: task.taskIcon.value,
      onPressed: () => taskLogic.sBtnLogic(task),
    );
  }

  Widget _taskTitleandProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: buildText(widget.task.name, context)),
        buildText(widget.task.progress.value, context),
      ],
    );
  }

  Widget _dltlSize(Task task) {
    if (task.status.value == TaskStatus.active) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildText(task.sizeRate.value, context),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: buildText(task.speedTime.value, context),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [buildText(task.sizeRate.value, context)],
      );
    }
  }

  Widget _delBtn() {
    return IconButton(
      color: context.textColor,
      onPressed: () => taskLogic.delBtn(widget.task),
      icon: Icon(Icons.delete),
    );
  }
}
