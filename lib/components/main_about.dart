import "package:flutter/material.dart";
import "package:fotrix/components/common.dart";
import "package:fotrix/store/config.dart";
import "package:fotrix/utils/theme.dart";
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
      mainAxisAlignment: .spaceBetween,
      children: [
        Column(
          children: [
            buildMainTitle("关于", context),
            buildDivider(),
            _buildXLText("fotrix"),
            buildText("Fotrix 是一个基于 Flutter 开发的aria2下载工具", context),
          ],
        ),
        SignalBuilder(
          builder: (_) => Padding(
            padding: const .only(bottom: 15),
            child: Column(
              children: [
                buildText("aria2: ${config.aria2Version}", context),
                buildText("v${config.version}", context),
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
        color: context.textColor,
        fontSize: 30,
        fontWeight: .bold,
      ),
    );
  }
}
