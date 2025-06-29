import 'package:flutter/material.dart';
import 'package:fotrix/models/aria2_client.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/models/logger.dart';
import 'package:fotrix/models/tray_service.dart';
import 'package:fotrix/home_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  await ts.initTray();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1000, 600),
    minimumSize: Size(730, 600),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // await windowManager.hide();
    await windowManager.focus();
  });
  await runLog.createLog();
  await config.loadConfig();
  await aria2Client.start();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 初始化配置
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    aria2Client.shutdownAria2();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // 应用关闭时调用关闭 Aria2 服务的方法
      aria2Client.shutdownAria2();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'HarmonyOS Sans',
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.normal),
          titleMedium: TextStyle(fontWeight: FontWeight.w500),
        ),
        brightness: config.darkMode ? Brightness.dark : Brightness.light,
      ),

      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
