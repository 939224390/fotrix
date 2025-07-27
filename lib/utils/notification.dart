// import 'package:fotrix/store/task.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:fotrix/store/tray_service.dart';

class Notification {
  Future<void> onStartDownload(List<String> gids) async {
    final res = await taskList.checkActive(gids);
    if (res) {
      ts.changeTrayIcon('active');
    }
  }

  Future<void> onFinishDownload() async {
    ts.changeTrayIcon('default');
  }
}


Notification notification = Notification();