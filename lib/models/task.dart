import 'package:signals/signals.dart';

enum TaskStatus { active, paused, complete, waiting, remove }

class Task {
  final String gid;
  final String url;
  final String name;
  final String savePath;
  final Signal<int> completedLength;
  final Signal<int> totalLength;
  final Signal<double> downloadSpeed;
  final Signal<TaskStatus> status;

  late final progress = computed(
    () =>
        totalLength.value != 0
            ? "${((completedLength.value / totalLength.value) * 100).toStringAsFixed(0)}%"
            : "0%",
  );

  late final dlSize = computed(() {
    List units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double res = completedLength.value.toDouble();
    int i = 0;
    for (i = 0; i < units.length; i++) {
      if (res < 1024) {
        break;
      } else {
        res = res / 1024;
      }
    }
    return "${res.toStringAsFixed(2)} ${units[i]}";
  });

  late final totalSize = computed(() {
    List units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double res = totalLength.value.toDouble();
    int i = 0;
    for (i = 0; i < units.length; i++) {
      if (res < 1024) {
        break;
      } else {
        res = res / 1024;
      }
    }
    return "${res.toStringAsFixed(2)} ${units[i]}";
  });

  late final formattedSpeed = computed(() {
    switch (downloadSpeed.value) {
      case <= 0:
        return "0 B/s";
      case < 1024:
        return "${downloadSpeed.value.toStringAsFixed(1)} B/s";
      case < 1024 * 1024:
        return "${(downloadSpeed.value / 1024).toStringAsFixed(1)} KB/s";

      default:
        return "${(downloadSpeed.value / (1024 * 1024)).toStringAsFixed(1)} MB/s";
    }
  });

  late final remainTime = computed(() {
    if (totalLength.value == 0 || downloadSpeed.value == 0) return "0";
    final remainBytes = totalLength.value - completedLength.value;
    final remainTime = (remainBytes / downloadSpeed.value).toInt();
    if (remainTime < 60) {
      return "$remainTime 秒";
    } else if (remainTime < 60 * 60) {
      return "${(remainTime / 60)} 分钟";
    } else {
      return "${(remainTime / 60 / 60)} 小时";
    }
  });


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

// String _calculateSpeed(Task task) {
//   switch (task.downloadSpeed.value) {
//     case <= 0:
//       return "0 B/s";
//     case < 1024:
//       return "${task.downloadSpeed.value.toStringAsFixed(1)} B/s";
//     case < 1024 * 1024:
//       return "${(task.downloadSpeed.value / 1024).toStringAsFixed(1)} KB/s";

//     default:
//       return "${(task.downloadSpeed.value / (1024 * 1024)).toStringAsFixed(1)} MB/s";
//   }
// }

// String _calculateRemainingTime(Task task) {
//   if (task.totalLength.value == 0 || task.downloadSpeed.value == 0) return "0";
//   final remainBytes = task.totalLength.value - task.completedLength.value;
//   final remainTime = (remainBytes / task.downloadSpeed.value).toInt();
//   if (remainTime < 60) {
//     return "$remainTime 秒";
//   } else if (remainTime < 60 * 60) {
//     return "${(remainTime / 60)} 分钟";
//   } else {
//     return "${(remainTime / 60 / 60)} 小时";
//   }
// }

// String _formatSize(int size) {
//   List units = ['B', 'KB', 'MB', 'GB', 'TB'];
//   double res = size.toDouble();
//   int i = 0;
//   for (i = 0; i < units.length; i++) {
//     if (res < 1024) {
//       break;
//     } else {
//       res = res / 1024;
//     }
//   }
//   return "${res.toStringAsFixed(2)} ${units[i]}";
// }
