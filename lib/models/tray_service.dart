import "dart:io";
import "package:fotrix/models/aria2_client.dart";
import "package:tray_manager/tray_manager.dart";
import "package:window_manager/window_manager.dart";

class TrayService {
  final TrayManager _tm = TrayManager.instance;

  //初始化托盘信息
  Future<void> initTray() async {
    final winIcon =
        Platform.isWindows
            ? 'assets/images/icon.ico'
            : 'assets/images/icon.png';
    await _tm.setIcon(winIcon);

    await _tm.setToolTip("Fotrx");

    await _tm.setContextMenu(
      Menu(
        items: [
          MenuItem(label: '显示主界面', onClick: (_) => windowManager.show()),
          MenuItem.separator(),
          MenuItem(
            label: '退出',
            onClick: (_) {
              aria2Client.shutdownAria2();
              exit(0);
            },
          ),
        ],
      ),
    );
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
