import 'package:flutter/material.dart';
import 'package:fotrix/store/config.dart';
import 'package:signals/signals_flutter.dart';

class PageInfo {
  // 分类索引
  final _pInd = signal(0);
  // 主页面索引
  final _mInd = signal(0);

  int get pInd => _pInd.value;
  int get mInd => _mInd.value;

  set pInd(int p) {
    _pInd.value = p;
  }

  set mInd(int m) {
    _mInd.value = m;
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
          tag: SideSubItemStatus.active,
          isSelect: true,
        ),
        SideSubItemInfo(
          icon: Icons.stop,
          title: "等待中",
          tag: SideSubItemStatus.waiting,
        ),
        SideSubItemInfo(
          icon: Icons.download_done,
          title: "已完成",
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
}

PageInfo pInf = PageInfo();

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
  String tag;
  bool isSelect;
  SideSubItemInfo({
    required this.icon,
    required this.title,
    required this.tag,
    this.isSelect = false,
  });
}

class SideSubItemStatus {
  static const String active = "active";
  static const String waiting = "waiting";
  static const String complete = "complete";
  static const String setting = "setting";
  static const String about = "about";
  static const String test = "test";
}
