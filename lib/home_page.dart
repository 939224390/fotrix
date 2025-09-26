import 'package:flutter/material.dart';
import 'package:fotrix/components/nav_bar.dart';
import 'package:fotrix/components/main_about.dart';
import 'package:fotrix/components/main_setting.dart';
import 'package:fotrix/components/side_setting.dart';
import 'package:fotrix/components/side_task.dart';
import 'package:fotrix/components/main_task.dart';
import 'package:fotrix/components/window_control.dart';
import 'package:fotrix/logic/page_logic.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/utils/tray_service.dart';
import 'package:fotrix/utils/color_mode.dart';
import 'package:signals/signals_flutter.dart';
import 'package:tray_manager/tray_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener {
  final logic = PageLogic();
  final data = pInf;
  @override
  Widget build(BuildContext context) {
    logic.init(context);
    return _buildMainLayout([
      //导航栏
      _buildNavBar(NavBar(data: data, onTap: (item) => logic.navLogic(item))),
      //侧边栏
      _buildSide([
        SideTask(data: data, onTap: (item) => logic.sideLogic(item)),
        SideSetting(data: data, onTap: (item) => logic.sideLogic(item)),
      ]),

      //页面栏
      _buildMain([
        MainTask(data: data),
        Watch(
          (_) => IndexedStack(
            index: pInf.mInd,
            children: [MainSetting(), MainAbout()],
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
  Widget _buildSide(List<Widget> children) {
    return Container(
      color: ColorTheme.sideColor.watch(context),
      width: 200,
      child: Column(
        children: [
          WindowControl(mode: "move"),
          Expanded(
            child: Watch(
              (_) => IndexedStack(index: pInf.pInd, children: children),
            ),
          ),
        ],
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
                (_) => IndexedStack(index: pInf.pInd, children: children),
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
