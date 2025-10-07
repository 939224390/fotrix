import 'package:flutter/material.dart';
import 'package:fotrix/components/add_task.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/page_info.dart';

class PageLogic {
  late BuildContext context;

  void init(BuildContext context) {
    this.context = context;
  }

  void changePage(int p) {
    pInf.mInd = 0;
    pInf.pInd = p;
  }

  void changeMain(int m) {
    pInf.mInd = m;
  }

  //导航栏逻辑
  void navLogic(NavItem item) {
    switch (item.tag) {
      case NavStatus.home:
        changePage(0);
        changeActive(TabStatus.active);
        break;
      case NavStatus.list:
        changePage(0);
        changeActive(TabStatus.active);
        break;
      case NavStatus.add:
        showDialog(context: context, builder: (context) => AddTask());
        break;
      case NavStatus.darkMode:
        config.changeTheme();
        break;
      case NavStatus.settings:
        changeActive(TabStatus.setting);
        changePage(1);
        break;
    }
  }

  //侧边栏逻辑
  void tabLogic(TabItem item) {
    switch (item.tag) {
      case TabStatus.active:
        changeMain(0);
        changeActive(TabStatus.active);
        break;
      case TabStatus.waiting:
        changeMain(1);
        changeActive(TabStatus.waiting);
        break;
      case TabStatus.complete:
        changeMain(2);
        changeActive(TabStatus.complete);
        break;
      case TabStatus.setting:
        changeMain(0);
        changeActive(TabStatus.setting);
        break;
      case TabStatus.about:
        changeMain(1);
        changeActive(TabStatus.about);
        break;
    }
  }

  //切换活动页
  void changeActive(String status) {
    for (var i in pInf.tabs) {
      for (var j in i.tabItems) {
        if (j.tag != status) {
          j.isSelect = false;
        } else {
          j.isSelect = true;
        }
      }
    }
  }
}
