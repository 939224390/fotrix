enum TaskStatus { downloading, paused, completed }

class Task {
  String gid;
  String name;
  String url;
  String savePath;
  int completedLength;
  int totalLength;
  double downloadSpeed;
  TaskStatus status;

  String get progress =>
      totalLength != 0
          ? "${((completedLength / totalLength) * 100).toStringAsFixed(0)}%"
          : "0%";
  String get dlSize => _formatSize(completedLength);
  String get totalSize => _formatSize(totalLength);
  String get formattedSpeed => _calculateSpeed(this);
  String get remainTime => _calculateRemainingTime(this);

  Task({
    required this.gid,
    required this.name,
    required this.url,
    required this.savePath,
    required this.completedLength,
    required this.totalLength,
    required this.downloadSpeed,
    required this.status,
  });

  String get tmpPath => "$savePath.aria2";
}

String _calculateSpeed(Task task) {
  switch (task.downloadSpeed) {
    case <= 0:
      return "0 B/s";
    case < 1024:
      return "${task.downloadSpeed.toStringAsFixed(1)} B/s";
    case < 1024 * 1024:
      return "${(task.downloadSpeed / 1024).toStringAsFixed(1)} KB/s";
    default:
      return "${(task.downloadSpeed / (1024 * 1024)).toStringAsFixed(1)} MB/s";
  }
}

String _calculateRemainingTime(Task task) {
  if (task.totalLength == 0 || task.downloadSpeed == 0) return "0";
  final remainBytes = task.totalLength - task.completedLength;
  final remainTime = (remainBytes / task.downloadSpeed).toInt();
  if (remainTime < 60) {
    return "$remainTime 秒";
  } else if (remainTime < 60 * 60) {
    return "${(remainTime / 60)} 分钟";
  } else {
    return "${(remainTime / 60 / 60)} 小时";
  }
}

String _formatSize(int size) {
  List units = ['B', 'KB', 'MB', 'GB', 'TB'];
  double res = size.toDouble();
  int i = 0;
  for (i = 0; i < units.length; i++) {
    if (res < 1024) {
      break;
    } else {
      res = res / 1024;
    }
  }
  return "${res.toStringAsFixed(2)} ${units[i]}";
}
