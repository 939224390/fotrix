import 'package:flutter/material.dart';
import 'package:fotrix/components/bar/nav_bar.dart';
import 'package:fotrix/models/page_info.dart';
import 'package:fotrix/models/tray_service.dart';
import 'package:fotrix/pages/setting_page.dart';
import 'package:fotrix/pages/task_page.dart';
import 'package:fotrix/components/window_control.dart';
import 'package:fotrix/models/config.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconRightMouseDown() {
    ts.mouseRightDown();
  }

  @override
  void onTrayIconMouseDown() {
    ts.onTrayIconClick();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Config, PageInfo>(
      builder: (context, config, pageInfo, child) {
        return Scaffold(
          body: Row(
            children: [
              Container(
                color: config.getColor("side"),
                width: 75,
                child: Column(
                  children: [
                    WindowControl(mode: "move"),
                    Expanded(child: NavBar()),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: pageInfo.pInd,
                  children: [TaskPage(), SettingPage()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
