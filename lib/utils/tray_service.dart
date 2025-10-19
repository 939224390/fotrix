import "dart:io";
import "package:flutter/material.dart";
import "package:fotrix/store/page_info.dart";
import "package:go_router/go_router.dart";
import "package:tray_manager/tray_manager.dart";
import "package:window_manager/window_manager.dart";
import "package:fotrix/api/aria2_api.dart";

class TrayService {
  final TrayManager _tm = TrayManager.instance;
  BuildContext? context;

  final iconDefault =
      Platform.isWindows
          ? 'assets/images/favicon.ico'
          : 'assets/images/favicon.png';
  final iconActive =
      Platform.isWindows
          ? "assets/images/active.ico"
          : "assets/images/active.png";
  String status = "default";

  Menu get menu => Menu(
    items: [
      MenuItem(
        label: 'Fotrix',
        onClick: (_) {
          pInf.mainIndex = 0;
          pInf.tabIndex = 0;
          context?.go("/task/active");
          windowManager.show();
        },
      ),
      MenuItem.separator(),
      MenuItem(
        label: "设置",
        onClick: (_) {
          pInf.mainIndex = 0;
          pInf.tabIndex = 1;
          context?.go("/setting/general");
          windowManager.show();
        },
      ),
      MenuItem(
        label: '退出',
        onClick: (_) async {
          await aria2Api.shutdown();
          exit(0);
        },
      ),
    ],
  );

  //初始化托盘信息
  Future<void> initTray() async {
    await _tm.setIcon(iconDefault);

    await _tm.setToolTip("Fotrx");

    await _tm.setContextMenu(menu);
  }

  void changeTrayIcon(String status) {
    switch (status) {
      case "active":
        _tm.setIcon(iconActive);
        this.status = "active";
        break;
      case "default":
        _tm.setIcon(iconDefault);
        this.status = "default";
        break;
    }
  }

  // 托盘图标点击事件
  void onTrayIconClick() async {
    if (await windowManager.isVisible()) {
      handleWindowClose();
    } else {
      windowManager.show();
    }
  }

  void mouseRightDown() {
    _tm.popUpContextMenu();
  }

  void handleWindowClose() async {
    await windowManager.hide();
    await initTray(); // 确保托盘初始化
  }

  void updateContext(BuildContext? newContext) {
    context = newContext;
    if (context != null) {
      _tm.setContextMenu(menu);
    }
  }
}

final ts = TrayService();
