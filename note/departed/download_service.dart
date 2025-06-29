/*
/ 使用Dio库实现下载
/
/ */



// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:fotrix/models/task.dart';
// import 'package:flutter/foundation.dart';
// import 'package:fotrix/models/task_list.dart';
// import 'package:flutter/material.dart';

// final Map<String, CancelToken> _cancelTokens = {};

// class DownloadService {
//   final dio = Dio();
//   //创建任务
//   void addTask(Task task) async {
//     if (_cancelTokens.containsKey(task.url)) {
//       debugPrint("任务已存在");
//       return;
//     }

//     final response = await dio.head(task.url);
//     if (response.headers.value('Accept-Ranges') != 'bytes') {
//       debugPrint("服务器不支持断点续传");
//     }

//     _cancelTokens[task.url] = task.cancelToken!;
//     task.lastUpdateTime = DateTime.now();
//     task.totalBytes = int.parse(response.headers.value("Content-Length")!);

//     _downloadFile(
//       task.url,
//       task.tmpPath,
//       (count, total) => _onReceiveProgress(task, count, total),
//       task.cancelToken,
//     );
//   }

//   // 任务暂停
//   void pauseTask(Task task) {
//     if (!_cancelTokens.containsKey(task.url)) {
//       debugPrint("任务不存在");
//       return;
//     }

//     _cancelTokens[task.url]!.cancel("paused");
//     _cancelTokens.remove(task.url);

//     task.pausedBytes = task.downloadBytes;
//     _fileInput(File(task.tmpPath), File(task.savePath));
//   }

//   // 继续任务
//   void resumeTask(Task task) async {
//     if (_cancelTokens.containsKey(task.url)) {
//       debugPrint("任务正在下载");
//       return;
//     }

//     final cancelToken = CancelToken();
//     _cancelTokens[task.url] = cancelToken;
//     task.cancelToken = cancelToken;

//     _downloadFile(
//       task.url,
//       task.tmpPath,
//       (count, total) => _onReceiveProgress(task, count, total),
//       cancelToken,
//       Options(
//         headers: {
//           HttpHeaders.rangeHeader: "bytes=${task.downloadBytes}-",
//           HttpHeaders.acceptRangesHeader: "bytes",
//         },
//       ),
//     );
//   }

//   //任务完成
//   void completeTask(Task task) async {
//     debugPrint("任务已完成");
//     if (await File(task.savePath).exists()) {
//       _fileInput(File(task.tmpPath), File(task.savePath));
//     } else {
//       final tmpFile = File(task.tmpPath);
//       tmpFile.rename(task.savePath);
//     }
//   }

//   void deleteTask(Task task) async {
//     if (_cancelTokens.containsKey(task.url)) {
//       _cancelTokens[task.url]!.cancel("delete");
//       _cancelTokens.remove(task.url);
//     }
//     if (await File(task.tmpPath).exists()) File(task.tmpPath).delete();
//     if (await File(task.savePath).exists()) File(task.savePath).delete();
//   }

//   //更新下载进度、速度、下载大小
//   void _onReceiveProgress(Task task, int count, int total) {
//     final tmpBytes = count + task.pausedBytes;
//     final now = DateTime.now();
//     final elapsed =
//         now.difference(task.lastUpdateTime ?? now).inMilliseconds / 1000;
//     if (elapsed >= 1) {
//       task.speed = (tmpBytes - task.downloadBytes) / elapsed;
//       task.downloadBytes = tmpBytes;
//       task.lastUpdateTime = now;
//     }
//     final rateio = tmpBytes / task.totalBytes;
//     if (rateio >= 1) {
//       task.downloadBytes = task.totalBytes;
//       taskList.completeTask(task);
//     }
//     taskList.refesh();
//   }

//   void _fileInput(File source, File target) async {
//     final sourceStream = source.openRead();
//     final targetStream = target.openWrite(mode: FileMode.append);
//     await targetStream.addStream(sourceStream);
//     await targetStream.flush();
//     await targetStream.close();
//     await source.delete();
//   }

//   //下载核心实现
//   Future<void> _downloadFile(
//     String url,
//     dynamic savePath,
//     ProgressCallback? onReceiveProgress,
//     CancelToken? cancelToken, [
//     Options? options,
//   ]) async {
//     int retryCount = 0;
//     int maxRetries = 3;
//     const initialRetryDelay = Duration(seconds: 1);
//     while (retryCount < maxRetries) {
//       try {
//         await dio.download(
//           url,
//           savePath,
//           onReceiveProgress: onReceiveProgress,
//           cancelToken: cancelToken,
//           deleteOnError: false,
//           options: options,
//         );
//         return;
//       } on DioException catch (e) {
//         if (e.type == DioExceptionType.cancel) {
//           return;
//         } else if (e.type == DioExceptionType.connectionTimeout ||
//             e.type == DioExceptionType.receiveTimeout ||
//             e.response?.statusCode == 429) {
//           retryCount++;
//           await Future.delayed(initialRetryDelay * retryCount);
//         } else {
//           debugPrint("下载失败: $e");
//         }
//       }
//     }
//     throw Exception("重连失败");
//   }
// }
