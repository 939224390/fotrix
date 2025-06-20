import 'package:flutter/material.dart';
import 'package:fotrix/models/aria2_client.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/models/page_info.dart';
import 'package:fotrix/models/task_list.dart';
import 'package:fotrix/models/tray_service.dart';
import 'package:fotrix/pages/home_page.dart';
import 'package:provider/provider.dart';
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
    await windowManager.show();
    await windowManager.focus();
  });

  aria2Client.start();
  config.initPowerBoot();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: config),
        ChangeNotifierProvider.value(value: pageInfo),
        ChangeNotifierProvider.value(value: taskList),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (context, conf, child) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'HarmonyOS Sans',
            textTheme: TextTheme(
              bodyMedium: TextStyle(fontWeight: FontWeight.normal),
              titleMedium: TextStyle(fontWeight: FontWeight.w500),
            ),
            brightness: conf.darkMode ? Brightness.dark : Brightness.light,
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      },
    );
  }
}
