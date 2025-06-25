import 'package:fotrix/utils/cross.dart';
import 'package:process_run/stdio.dart';

class Logger {
  late String _logPath = "";

  createLog() async {
    _logPath = await Cross().createLog();
  }

  log(String msg) async {
    String time = DateTime.now().toString();
    final logFile = File(_logPath);
    await logFile.writeAsString("[$time] $msg\n", mode: FileMode.append);
  }
}

Logger runLog = Logger();
