import 'package:fotrix/utils/cross.dart';
import 'package:process_run/stdio.dart';

class Logger {
  late String _logPath = "";
  File? logFile;

  Future<void> initLog() async {
    _logPath = await Cross().createLog();
    logFile = File(_logPath);
  }

  Future<void> checkLog() async {
    logFile = File(_logPath);
    if (!await logFile!.exists()) {
      await initLog();
    }
  }

  Future<void> info(String msg) async {
    String time = DateTime.now().toString();
    await checkLog();
    await logFile?.writeAsString(
      "[$time] [INFO] $msg\n",
      mode: FileMode.append,
    );
  }

  Future<void> debug(String msg) async {
    String time = DateTime.now().toString();
    await checkLog();
    await logFile?.writeAsString(
      "[$time] [DEBUG] $msg\n",
      mode: FileMode.append,
    );
  }

  Future<void> error(String msg) async {
    String time = DateTime.now().toString();
    await checkLog();
    await logFile?.writeAsString(
      "[$time] [ERROR] $msg\n",
      mode: FileMode.append,
    );
  }
}

Logger logger = Logger();
