import 'package:hive/hive.dart';

Box? configBox;

Future<void> initConfig() async {
  configBox = await Hive.openBox('config');
}

//深色模式
void setDarkMode(bool value) {
  _upInfo('darkMode', value);
}

bool get getDarkMode {
  final res = _getInfo('darkMode');
  if (res != null) {
    return res;
  } else {
    setDarkMode(true);
    return true;
  }
}

//开机自启
void setPowerBoot(bool value) {
  _upInfo('powerBoot', value);
}

bool get getPowerBoot {
  final res = _getInfo('powerBoot');
  if (res != null) {
    return res;
  } else {
    setPowerBoot(false);
    return false;
  }
}

//线程数量
void setThreadCount(int value) {
  _upInfo('threadCount', value);
}

int get getThreadCount {
  final res = _getInfo('threadCount');
  if (res != null) {
    return res;
  } else {
    setThreadCount(6);
    return 6;
  }
}

//保存路径
void setSavePath(String value) {
  _upInfo('savePath', value);
}

String get getSavePath {
  final res = _getInfo('savePath');
  if (res != null) {
    return res;
  } else {
    setSavePath('D:\\Download');
    return 'D:\\Download';
  }
}

//最大下载数量
void setMaxDown(int value) {
  _upInfo('maxDown', value);
}

int get getMaxDown {
  final res = _getInfo('maxDown');
  if (res != null) {
    return res;
  } else {
    setMaxDown(6);
    return 6;
  }
}

void _upInfo(String key, dynamic value) {
  configBox?.put(key, value);
}

dynamic _getInfo(String key) {
  final value = configBox?.get(key);  
  return value;
}

void closeConfigBox() {
  configBox?.close();
}
