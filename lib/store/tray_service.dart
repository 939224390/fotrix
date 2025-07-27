import "dart:io";
import "package:fotrix/store/aria2_manager.dart";
import "package:fotrix/store/page_info.dart";
import "package:tray_manager/tray_manager.dart";
import "package:window_manager/window_manager.dart";

class TrayService {
  final TrayManager _tm = TrayManager.instance;

  final iconDefault =
      Platform.isWindows
          ? 'assets/images/favicon.ico'
          : 'assets/images/favicon.png';
  final iconActive =
      Platform.isWindows
          ? "assets/images/active.ico"
          : "assets/images/active.png";

  final menu = Menu(
    items: [
      MenuItem(
        label: 'Fotrix',
        onClick: (_) {
          pInf.mInd = 0;
          pInf.pInd = 0;
          windowManager.show();
        },
      ),
      MenuItem.separator(),
      MenuItem(
        label: "设置",
        onClick: (_) {
          pInf.mInd = 0;
          pInf.pInd = 1;
          windowManager.show();
        },
      ),
      MenuItem(
        label: '退出',
        onClick: (_) async {
          await a2M.shutdown();
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
        break;
      case "default":
        _tm.setIcon(iconDefault);
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
}

final ts = TrayService();
