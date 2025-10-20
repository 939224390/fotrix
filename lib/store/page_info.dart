import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class PageInfo {
  // 选项卡组
  final _tabIndex = signal(0);
  // 页面
  final _mainIndex = signal(0);

  int get tabIndex => _tabIndex.value;
  int get mainIndex => _mainIndex.value;

  set tabIndex(int t) {
    _tabIndex.value = t;
  }

  set mainIndex(int m) {
    _mainIndex.value = m;
  }

  // 导航栏图标
  late List<NavItem> navTop;
  late List<NavItem> navBtm;

  late List<TabsItem> tabs;

  PageInfo() {
    //导航栏上部选项
    navTop = [
      NavItem(Icons.home, NavStatus.home),
      NavItem(Icons.menu, NavStatus.list),
      NavItem(Icons.add, NavStatus.add),
    ];
    //导航栏下部选项
    navBtm = [
      NavItem(Icons.light_mode, NavStatus.darkMode),
      NavItem(Icons.settings, NavStatus.settings),
    ];
    //侧边栏选项
    tabs = [
      TabsItem("任务列表", [
        TabItem(
          icon: Icons.star,
          title: "全部",
          tag: TabStatus.total,
          isSelect: true,
        ),
        TabItem(icon: Icons.play_arrow, title: "下载中", tag: TabStatus.active),
        TabItem(icon: Icons.stop, title: "等待中", tag: TabStatus.waiting),
        TabItem(
          icon: Icons.download_done,
          title: "已完成",
          tag: TabStatus.complete,
        ),
      ]),
      TabsItem("设置", [
        TabItem(
          icon: Icons.settings,
          title: "设置",
          tag: TabStatus.setting,
          isSelect: true,
        ),
        TabItem(icon: Icons.report, title: "关于", tag: TabStatus.about),
      ]),
    ];
  }
}

PageInfo pInf = PageInfo();

class NavItem {
  IconData icon;
  String? tag;
  NavItem(this.icon, this.tag);
}

class NavStatus {
  static const String home = "home";
  static const String list = "list";
  static const String add = "add";
  static const String darkMode = "darkMode";
  static const String settings = "settings";
}

//选项卡组
class TabsItem {
  String title;
  List<TabItem> tabItems;
  TabsItem(this.title, this.tabItems);
}

//选项卡
class TabItem {
  IconData icon;
  String title;
  String tag;
  bool isSelect;
  TabItem({
    required this.icon,
    required this.title,
    required this.tag,
    this.isSelect = false,
  });
}

class TabStatus {
  static const String total = "total";
  static const String active = "active";
  static const String waiting = "waiting";
  static const String complete = "complete";
  static const String setting = "setting";
  static const String advanced = "advanced";
  static const String about = "about";
}
