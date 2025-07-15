import "package:flutter/material.dart";
import "package:fotrix/utils/color_mode.dart";
import "package:fotrix/utils/common.dart";
import "package:fotrix/store/config.dart";
import "package:signals/signals_flutter.dart";

class MainAbout extends StatefulWidget {
  const MainAbout({super.key});

  @override
  State<MainAbout> createState() => _MainAboutState();
}

class _MainAboutState extends State<MainAbout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            buildMainTitle("关于"),
            buildDivider(),
            _buildXLText("fotrix"),
            buildText("Fotrix 是一个基于 Flutter 开发的aria2下载工具"),
          ],
        ),
        Watch(
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                buildText("aria2: ${config.aria2Version}"),
                buildText("v${config.version}"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildXLText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: ColorTheme.textColor.value,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
