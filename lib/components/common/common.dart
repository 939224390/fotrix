import 'package:flutter/material.dart';
import 'package:fotrix/models/config.dart';


Widget buildText(String text) {
  return Text(text, style: TextStyle(color: config.getColor("text")));
}

Widget buildIcon(IconData icon) {
  return Icon(icon, color: config.getColor("text"));
}

Widget buildDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Divider(),
  );
}

Widget buildTitle(String text) {
  return Padding(padding: const EdgeInsets.all(12.0), child: buildText(text));
}
