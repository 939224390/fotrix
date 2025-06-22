import 'package:flutter/material.dart';
import 'package:fotrix/components/bar/page_side.dart';
import 'package:fotrix/components/main/about_main.dart';
import 'package:fotrix/components/main/setting_main.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/models/page_info.dart';
import 'package:fotrix/utils/common.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<Config, PageInfo>(
      builder: (context, config, pageInfo, child) {
        return Row(
          children: [
            buildSideContainer(PageSide()),
            Expanded(
              child: buildMainContainer(
                IndexedStack(
                  index: pageInfo.mInd,
                  children: [SettingMain(), AboutMain()],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
