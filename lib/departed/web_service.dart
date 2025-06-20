// import "dart:convert";
// import "package:flutter/foundation.dart";
// import "package:fotrix/models/task_list.dart";
// import "package:shelf/shelf.dart";
// import "package:shelf_router/shelf_router.dart";
// import 'package:shelf/shelf_io.dart' as shelf_io;

// class WebService {
//   void startServer() async {
//     final router = Router();
//     corsMiddleware(Handler innerHandler) {
//       return (Request request) async {
//         final response = await innerHandler(request);
//         return response.change(
//           headers: {
//             'Access-Control-Allow-Origin':
//                 'chrome-extension://fiddjeppmbnoeboppjnojboefaddogab',
//             'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
//             'Access-Control-Allow-Headers': 'Content-Type, Authorization',
//             'Access-Control-Allow-Credentials': 'true', // 允许凭证（如 Cookies）
//           },
//         );
//       };
//     }

//     router.get("/connect", (Request req) async {
//       return Response.ok('Data');
//     });
//     router.post("/download", (Request req) async {
//       try {
//         final body = await req.readAsString();
//         final Map<String, dynamic> data = jsonDecode(body);
//         final String url = data['url'];
//         debugPrint(url);

//         taskList.createTask(url);

//         return Response.ok("get it");
//       } catch (e) {
//         debugPrint("download error: $e");
//       }
//     });
//     router.options('/download', (Request request) {
//       return Response.ok('123');
//     });
//     final handler = Pipeline()
//         .addMiddleware(corsMiddleware)
//         .addMiddleware(logRequests())
//         .addHandler(router.call);
//     final server = await shelf_io.serve(handler, 'localhost', 16809);

//     debugPrint(
//       'Server running on http://${server.address.host}:${server.port}',
//     );
//   }
// }
