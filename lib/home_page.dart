import 'package:flutter/material.dart';
import 'package:fotrix/components/nav_bar.dart';
import 'package:fotrix/components/page_side.dart';
import 'package:fotrix/components/about_main.dart';
import 'package:fotrix/components/setting_main.dart';
import 'package:fotrix/components/task_main.dart';
import 'package:fotrix/components/window_control.dart';
import 'package:fotrix/utils/logic.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/store/tray_service.dart';
import 'package:fotrix/store/config.dart';
import 'package:signals/signals_flutter.dart';
import 'package:tray_manager/tray_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener {
  final logic = FotrixLogic();
  final data = FotrixLogic().state;
  @override
  Widget build(BuildContext context) {
    logic.init(context);
    return _buildMainLayout([
      //导航栏
      _buildNavBar(
        NavBar(data: data, onTap: (item) => logic.navigationLogic(item)),
      ),
      //侧边栏
      _buildSide(PageSide(data: data, onTap: (item) => logic.sideLogic(item))),
      //页面栏
      _buildMain([
        TaskMain(
          data: data,
          resume: () => logic.resumeAllTask,
          stop: () => logic.stopAllTask,
        ),
        Watch(
          (_) => IndexedStack(
            index: pageInfo.mInd.value,
            children: [SettingMain(), AboutMain()],
          ),
        ),
      ]),
    ]);
  }

  //整体布局
  Widget _buildMainLayout(List<Widget> children) {
    return Scaffold(body: Row(children: children));
  }

  ///侧边导航
  Widget _buildNavBar(Widget child) {
    return Container(
      color: ColorTheme.navColor.watch(context),
      width: 75,
      child: Column(
        children: [WindowControl(mode: "move"), Expanded(child: child)],
      ),
    );
  }

  ///侧边导航
  Widget _buildSide(Widget child) {
    return Container(
      color: ColorTheme.sideColor.watch(context),
      width: 200,
      child: Column(
        children: [WindowControl(mode: "move"), Expanded(child: child)],
      ),
    );
  }

  Widget _buildMain(List<Widget> children) {
    return Expanded(
      child: Container(
        color: ColorTheme.mainColor.watch(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WindowControl(mode: "ctrl"),
            Expanded(
              child: Watch(
                (_) => IndexedStack(
                  index: pageInfo.pInd.value,
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}
