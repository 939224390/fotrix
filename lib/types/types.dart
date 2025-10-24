class Response {
  int code;
  dynamic data;

  Response(this.code, this.data);
}

class UConfig {
  String savePath;
  int threadCount;
  int maxDown;
  bool enableAria2Log;
  int port;
  UConfig({
    required this.savePath,
    required this.threadCount,
    required this.maxDown,
    required this.enableAria2Log,
    required this.port,
  });
}
