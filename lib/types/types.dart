class Response {
  int code;
  dynamic data;

  Response(this.code, this.data);
}

class UConfig {
  String savePath;
  int threadCount;
  int maxDown;
  UConfig({
    required this.savePath,
    required this.threadCount,
    required this.maxDown,
  });
}
