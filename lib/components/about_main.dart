import "package:flutter/material.dart";
import "package:fotrix/utils/common.dart";
import "package:fotrix/models/config.dart";
import "package:signals/signals_flutter.dart";

class AboutMain extends StatefulWidget {
  const AboutMain({super.key});

  @override
  State<AboutMain> createState() => _AboutMainState();
}

class _AboutMainState extends State<AboutMain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            buildMainTitle("关于"),
            buildDivider(),
            buildXLText("fotrix"),
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
}
