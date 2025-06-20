import "package:flutter/material.dart";
import "package:fotrix/components/common/common.dart";
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
                buildTitle("关于"),
                buildDivider(),
                Text(
                  "Fotrix",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: config.getColor("text"),
                  ),
                ),

                buildText("Fotrix 是一个基于 Flutter 开发的aria2下载工具"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  buildText("Engine 1.37.0"),
                  buildText("Version 0.0.1"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
