import 'package:flutter/material.dart';
import 'package:fotrix/utils/theme.dart';

//默认字体
Widget buildText(String text, BuildContext ctx) {
  return Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(color: Theme.of(ctx).fTheme.text),
  );
}

//大号字体
Widget buildLText(String text, BuildContext ctx) {
  return Text(
    text,
    style: TextStyle(color: Theme.of(ctx).fTheme.text, fontSize: 20),
  );
}

//默认图标
Widget buildIcon(IconData icon, BuildContext ctx) {
  return Icon(icon, color: Theme.of(ctx).fTheme.text);
}

//默认分隔线
Widget buildDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Divider(),
  );
}

///内容标题
Widget buildMainTitle(String text, BuildContext ctx) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: buildText(text, ctx),
  );
}

Widget buildSavePathBtn(
  void Function()? onPressed,
  Widget child,
  BuildContext ctx,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(ctx).fTheme.btn,
      elevation: 0,
      side: BorderSide.none,
    ),
    onPressed: onPressed,
    child: child,
  );
}
