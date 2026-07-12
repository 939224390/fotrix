import 'package:flutter/material.dart';
import 'package:fotrix/components/main_about.dart';
import 'package:fotrix/components/main_advanced.dart';
import 'package:fotrix/components/main_setting.dart';
import 'package:fotrix/components/main_task.dart';
import 'package:fotrix/components/nav_bar.dart';
import 'package:fotrix/components/tabs_bar.dart';
import 'package:fotrix/components/window_control.dart';
import 'package:fotrix/logic/page_logic.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/utils/theme.dart';
import 'package:go_router/go_router.dart';

final data = pInf;
final logic = PageLogic();

final taskId = {"total": 0, "active": 1, "waiting": 2, "complete": 3};
final settingPage = {
  "general": MainSetting(),
  "advanced": MainAdvanced(),
  "about": MainAbout(),
};

class SmoothTransitionPage<T> extends Page<T> {
  final Widget child;

  const SmoothTransitionPage({required super.key, required this.child});

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
          reverseCurve: Curves.easeInQuart,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.008, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: ColoredBox(color: context.mainColor, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 120),
      reverseTransitionDuration: const Duration(milliseconds: 100),
    );
  }
}

final router = GoRouter(
  initialLocation: "/task/total",

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: Row(
            children: [
              _buildNavBar(
                NavBar(
                  data: data,
                  onTap: (item) => logic.navLogic(item, context),
                ),
                context,
              ),
              _buildTabBar(
                TabsBar(
                  data: data,
                  onTap: (item) => logic.tabLogic(item, context),
                ),
                context,
              ),
              _buildMain(child, context),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: "/task/:id",
          pageBuilder: (context, state) => SmoothTransitionPage(
            key: ValueKey(state.uri.path),
            child: MainTask(
              data: data,
              index: taskId[state.pathParameters["id"]]!,
            ),
          ),
        ),
        GoRoute(
          path: "/setting/:id",
          pageBuilder: (context, state) => SmoothTransitionPage(
            key: ValueKey(state.uri.path),
            child: settingPage[state.pathParameters["id"]]!,
          ),
        ),
      ],
    ),
  ],
);

///导航
Widget _buildNavBar(Widget child, BuildContext context) {
  return Container(
    color: context.navColor,
    width: 75,
    child: Column(
      children: [
        WindowControl(mode: "move"),
        Expanded(child: child),
      ],
    ),
  );
}

///选项卡组
Widget _buildTabBar(Widget child, BuildContext context) {
  return Container(
    color: context.sideColor,
    width: 200,
    child: Column(
      children: [
        WindowControl(mode: "move"),
        Expanded(child: child),
      ],
    ),
  );
}

// 选项卡
Widget _buildMain(Widget child, BuildContext context) {
  return Expanded(
    child: Container(
      color: context.mainColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WindowControl(mode: "ctrl"),
          Expanded(child: child),
        ],
      ),
    ),
  );
}
