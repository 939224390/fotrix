import 'package:flutter/material.dart';
import 'package:fotrix/models/config.dart';
import 'package:signals/signals_flutter.dart';

class PageInfo {
  // 分类索引
  final pInd = signal(0);
  // 主页面索引
  final mInd = signal(0);

  void changePage(int p) {
    mInd.value = 0;
    pInd.value = p;
  }

  void changeMain(int m) {
    mInd.value = m;
  }

  // 导航栏图标
  late List<NavBarItemInfo> navBarTopItem;

  late Computed<List<NavBarItemInfo>> navBarBottomItem;
  late List<NavBarItemInfo> navBarBottomItemDark;
  late List<NavBarItemInfo> navBarBottomItemmLight;
  late List<SideItemInfo> sideItem;

  PageInfo() {
    //导航栏上部选项
    navBarTopItem = [
      NavBarItemInfo(Icons.home, NavBarItemStatus.home),
      NavBarItemInfo(Icons.menu, NavBarItemStatus.list),
      NavBarItemInfo(Icons.add, NavBarItemStatus.add),
    ];
    //导航栏下部选项
    navBarBottomItemDark = [
      NavBarItemInfo(Icons.light_mode, NavBarItemStatus.darkMode),
      NavBarItemInfo(Icons.settings, NavBarItemStatus.settings),
    ];
    navBarBottomItemmLight = [
      NavBarItemInfo(Icons.dark_mode, NavBarItemStatus.darkMode),
      NavBarItemInfo(Icons.settings, NavBarItemStatus.settings),
    ];
    navBarBottomItem = computed(
      () => config.darkMode ? navBarBottomItemDark : navBarBottomItemmLight,
    );
    //侧边栏选项
    sideItem = [
      SideItemInfo("任务列表", [
        SideSubItemInfo(
          icon: Icons.play_arrow,
          title: "下载中",
          subTitle: "0",
          tag: SideSubItemStatus.active,
          isSelect: true,
        ),
        SideSubItemInfo(
          icon: Icons.stop,
          title: "等待中",
          subTitle: "0",
          tag: SideSubItemStatus.waiting,
        ),
        SideSubItemInfo(
          icon: Icons.pause,
          title: "已暂停",
          subTitle: "0",
          tag: SideSubItemStatus.paused,
        ),
        SideSubItemInfo(
          icon: Icons.download_done,
          title: "已完成",
          subTitle: "0",
          tag: SideSubItemStatus.complete,
        ),
      ]),
      SideItemInfo("设置", [
        SideSubItemInfo(
          icon: Icons.settings,
          title: "设置",
          tag: SideSubItemStatus.setting,
          isSelect: true,
        ),
        SideSubItemInfo(
          icon: Icons.report,
          title: "关于",
          tag: SideSubItemStatus.about,
        ),
      ]),
    ];
  }

  List<List<String>> sideBtn = [
    ["下载中", "等待中", "已暂停", "已完成"],
    ["设置", "关于"],
  ];
}

PageInfo pageInfo = PageInfo();

class NavBarItemInfo {
  IconData icon;
  String? tag;
  NavBarItemInfo(this.icon, this.tag);
}

class NavBarItemStatus {
  static const String home = "home";
  static const String list = "list";
  static const String add = "add";
  static const String darkMode = "darkMode";
  static const String settings = "settings";
}

class SideItemInfo {
  String title;
  List<SideSubItemInfo> subItems;
  SideItemInfo(this.title, this.subItems);
}

class SideSubItemInfo {
  IconData icon;
  String title;
  String? subTitle;
  String tag;
  bool isSelect;
  SideSubItemInfo({
    required this.icon,
    required this.title,
    this.subTitle,
    required this.tag,
    this.isSelect = false,
  });
}

class SideSubItemStatus {
  static const String active = "active";
  static const String waiting = "waiting";
  static const String paused = "paused";
  static const String complete = "complete";
  static const String setting = "setting";
  static const String about = "about";
  static const String test = "test";
}
