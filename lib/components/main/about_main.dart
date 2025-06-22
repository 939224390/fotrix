import "package:flutter/material.dart";
import "package:fotrix/utils/common.dart";
import "package:fotrix/models/config.dart";
import "package:provider/provider.dart";

class AboutMain extends StatefulWidget {
  const AboutMain({super.key});

  @override
  State<AboutMain> createState() => _AboutMainState();
}

class _AboutMainState extends State<AboutMain> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (context, config, child) {
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
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  buildText("Aria2 Version: ${config.aria2Version}"),
                  buildText("Version 0.1.0"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
