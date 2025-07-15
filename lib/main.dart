import 'package:flutter/material.dart';
import 'package:fotrix/store/aria2_manager.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/logger.dart';
import 'package:fotrix/store/tray_service.dart';
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

  await logger.initLog();
  await config.loadConfig();
  await a2M.start();

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
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await a2M.shutdown();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      // 应用关闭时调用关闭 Aria2 服务的方法
      await a2M.shutdown();
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
