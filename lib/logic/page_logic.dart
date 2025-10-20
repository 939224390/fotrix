import 'package:flutter/material.dart';
import 'package:fotrix/components/add_task.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:go_router/go_router.dart';

class PageLogic {
  void changeTab(int p) {
    pInf.mainIndex = 0;
    pInf.tabIndex = p;
  }

  void changeMain(int m) {
    pInf.mainIndex = m;
  }

  //导航栏逻辑
  void navLogic(NavItem item, BuildContext context) {
    switch (item.tag) {
      case NavStatus.home:
        context.go("/task/total");
        changeTab(0);
        changeActive(TabStatus.total);
        break;
      case NavStatus.list:
        context.go("/task/total");
        changeTab(0);
        changeActive(TabStatus.total);
        break;
      case NavStatus.add:
        showDialog(context: context, builder: (context) => AddTask());
        break;
      case NavStatus.darkMode:
        config.changeTheme();
        break;
      case NavStatus.settings:
        changeActive(TabStatus.setting);
        changeTab(1);
        context.go("/setting/general");
        break;
    }
  }

  //侧边栏逻辑
  void tabLogic(TabItem item, BuildContext context) {
    switch (item.tag) {
      case TabStatus.total:
        context.go("/task/total");
        changeMain(0);
        changeActive(TabStatus.total);
        break;
      case TabStatus.active:
        context.go("/task/active");
        changeMain(1);
        changeActive(TabStatus.active);
        break;
      case TabStatus.waiting:
        context.go("/task/waiting");
        changeMain(2);
        changeActive(TabStatus.waiting);
        break;
      case TabStatus.complete:
        context.go("/task/complete");
        changeMain(3);
        changeActive(TabStatus.complete);
        break;
      case TabStatus.setting:
        context.go("/setting/general");
        changeMain(0);
        changeActive(TabStatus.setting);
        break;
      case TabStatus.about:
        context.go("/setting/about");
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
