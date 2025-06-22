import 'package:flutter/material.dart';
import 'package:fotrix/models/task_list.dart';
import 'package:fotrix/utils/common.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _urlCtrler = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  //获取焦点
  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _urlCtrler.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskList>(
      builder: (context, taskList, child) {
        return buildAddTaskDialog([
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _urlCtrler,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: "请输入下载链接",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _createDownloadTask(), // 回车触发
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createDownloadTask,
                  child: Text("开始下载"),
                ),
              ],
            ),
          ),
        ]);
      },
    );
  }

  //创建下载任务
  void _createDownloadTask() async {
    if (_urlCtrler.text.isEmpty) {
      _buildSnackBar("下载链接不能为空");
      return;
    }
    final success = await taskList.createTask(_urlCtrler.text);
    if (!mounted) return;
    if (!success) {
      _buildSnackBar("当前任务已存在");
    }

    Navigator.pop(context); // 关闭对话框
  }

  void _buildSnackBar(String content) {
    final snackBar = SnackBar(content: Text(content));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
