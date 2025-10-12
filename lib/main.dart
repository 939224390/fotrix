import 'package:flutter/material.dart';
import 'package:fotrix/action.dart';
import 'package:fotrix/router.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/utils/theme.dart';
import 'package:fotrix/utils/tray_service.dart';
import 'package:signals/signals_flutter.dart';
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
    await windowManager.focus();
  });

  await AppAction.init();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return MaterialApp.router(
        theme: ThemeManager.lightTheme,
        darkTheme: ThemeManager.darkTheme,
        themeMode: config.darkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      );
    });
  }
}
