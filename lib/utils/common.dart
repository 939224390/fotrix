import 'package:flutter/material.dart';
import 'package:fotrix/store/config.dart';

//默认字体
Widget buildText(String text) {
  return Text(text, style: TextStyle(color: ColorTheme.textColor.value));
}

//大号字体
Widget buildLText(String text) {
  return Text(
    text,
    style: TextStyle(color: ColorTheme.textColor.value, fontSize: 20),
  );
}

Widget buildXLText(String text) {
  return Text(
    text,
    style: TextStyle(
      color: ColorTheme.textColor.value,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
}

//默认图标
Widget buildIcon(IconData icon) {
  return Icon(icon, color: ColorTheme.textColor.value);
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

///添加任务对话框
Widget buildAddTaskDialog(List<Widget> children) {
  return SimpleDialog(
    backgroundColor: ColorTheme.cardColor.value,
    title: buildText("新建下载任务"),
    children: children,
  );
}

Widget buildTaskCard(Widget child) {
  return Card(color: ColorTheme.cardColor.value, child: child);
}

Widget buildSavePathBtn(void Function()? onPressed, Widget child) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorTheme.btnColor.value,
      elevation: 0,
      side: BorderSide.none,
    ),
    onPressed: onPressed,
    child: child,
  );
}
