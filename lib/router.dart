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

final taskId = {"active": 0, "waiting": 1, "complete": 2};
final settingPage = {
  "general": MainSetting(),
  "advanced": MainAdvanced(),
  "about": MainAbout(),
};

class NoTransitionPage<T> extends Page<T> {
  final Widget child;

  NoTransitionPage({required this.child}) : super(key: ValueKey(child));

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}

final router = GoRouter(
  initialLocation: "/task/active",

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
              Expanded(child: child),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: "/task/:id",
          pageBuilder:
              (context, state) => NoTransitionPage(
                child: Row(
                  children: [
                    _buildTabBar(
                      TabsBar(
                        data: data,
                        onTap: (item) => logic.tabLogic(item, context),
                      ),
                      context,
                    ),
                    _buildMain(
                      MainTask(
                        data: data,
                        index: taskId[state.pathParameters["id"]]!,
                      ),
                      context,
                    ),
                  ],
                ),
              ),
        ),
        GoRoute(
          path: "/setting/:id",
          pageBuilder:
              (context, state) => NoTransitionPage(
                child: Row(
                  children: [
                    _buildTabBar(
                      TabsBar(
                        data: data,
                        onTap: (item) => logic.tabLogic(item, context),
                      ),
                      context,
                    ),
                    _buildMain(
                      settingPage[state.pathParameters["id"]]!,
                      context,
                    ),
                  ],
                ),
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
      children: [WindowControl(mode: "move"), Expanded(child: child)],
    ),
  );
}

///选项卡组
Widget _buildTabBar(Widget child, BuildContext context) {
  return Container(
    color: context.sideColor,
    width: 200,
    child: Column(
      children: [WindowControl(mode: "move"), Expanded(child: child)],
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
        children: [WindowControl(mode: "ctrl"), Expanded(child: child)],
      ),
    ),
  );
}
