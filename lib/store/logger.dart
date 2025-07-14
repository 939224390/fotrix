import 'package:fotrix/utils/cross.dart';
import 'package:process_run/stdio.dart';

class Logger {
  late String _logPath = "";
  File? logFile;

  initLog() async {
    _logPath = await Cross().createLog();
    logFile = File(_logPath);
  }

  checkLog() async {
    logFile = File(_logPath);
    if (!await logFile!.exists()) {
      await initLog();
    }
  }

  info(String msg) async {
    String time = DateTime.now().toString();
    await checkLog();
    await logFile?.writeAsString(
      "[$time] [INFO] $msg\n",
      mode: FileMode.append,
    );
  }

  error(String msg) async {
    String time = DateTime.now().toString();
    await checkLog();
    await logFile?.writeAsString(
      "[$time] [ERROR] $msg\n",
      mode: FileMode.append,
    );
  }
}

Logger logger = Logger();
