import 'package:flutter/material.dart';
import 'package:fotrix/components/bar/page_side.dart';
import 'package:fotrix/components/main/about_main.dart';
import 'package:fotrix/components/main/setting_main.dart';
import 'package:fotrix/components/window_control.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/models/page_info.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<Config, PageInfo>(
      builder: (context, config, pageInfo, child) {
        return Row(
          children: [
            Container(
              color: config.getColor("bar"),
              width: 200,
              child: Column(
                children: [
                  WindowControl(mode: "move"),
                  Expanded(child: PageSide()),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: config.getColor("main"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WindowControl(mode: "ctrl"),
                    Expanded(
                      child: IndexedStack(
                        index: pageInfo.mInd,
                        children: [SettingMain(), AboutMain()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
