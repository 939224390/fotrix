import 'package:flutter/material.dart';
import 'package:fotrix/components/window_control.dart';
import 'package:fotrix/models/config.dart';

//默认字体
Widget buildText(String text) {
  return Text(text, style: TextStyle(color: config.getColor("text")));
}

//大号字体
Widget buildLText(String text) {
  return Text(
    text,
    style: TextStyle(color: config.getColor("text"), fontSize: 20),
  );
}

Widget buildXLText(String text) {
  return Text(
    text,
    style: TextStyle(
      color: config.getColor("text"),
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
}

//默认图标
Widget buildIcon(IconData icon) {
  return Icon(icon, color: config.getColor("text"));
}

//默认分隔线
Widget buildDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Divider(),
  );
}

///内容标题
Widget buildMainTitle(String text) {
  return Padding(padding: const EdgeInsets.all(12.0), child: buildText(text));
}

///侧边标题
Widget buildSideTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: buildLText(text),
  );
}

///侧边导航
Widget buildNavBarContainer(Widget child) {
  return Container(
    color: config.getColor("nav"),
    width: 75,
    child: Column(
      children: [WindowControl(mode: "move"), Expanded(child: child)],
    ),
  );
}

///侧边导航
Widget buildSideContainer(Widget child) {
  return Container(
    color: config.getColor("side"),
    width: 200,
    child: Column(
      children: [WindowControl(mode: "move"), Expanded(child: child)],
    ),
  );
}

///内容区域
Widget buildMainContainer(Widget child) {
  return Container(
    color: config.getColor("main"),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [WindowControl(mode: "ctrl"), Expanded(child: child)],
    ),
  );
}

///添加任务对话框
Widget buildAddTaskDialog(List<Widget> children) {
  return SimpleDialog(
    backgroundColor: config.getColor("card"),
    title: buildText("新建下载任务"),
    children: children,
  );
}

Widget buildTaskCard(Widget child) {
  return Card(color: config.getColor("card"), child: child);
}

Widget buildSavePathBtn(void Function()? onPressed, Widget child) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: config.getColor("main"),
      elevation: 0,
      side: BorderSide.none,
    ),
    onPressed: onPressed,
    child: child,
  );
}
