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

  void navLogic(NavBarItemInfo item) {
    switch (item.tag) {
      case NavBarItemStatus.home:
        changePage(0);
        changeActive(SideSubItemStatus.active);
        break;
      case NavBarItemStatus.list:
        changePage(0);
        changeActive(SideSubItemStatus.active);
        break;
      case NavBarItemStatus.add:
        showDialog(context: context, builder: (context) => AddTask());
        break;
      case NavBarItemStatus.darkMode:
        config.changeTheme();
        break;
      case NavBarItemStatus.settings:
        changeActive(SideSubItemStatus.setting);
        changePage(1);
        break;
    }
  }

  void sideLogic(SideSubItemInfo item) {
    switch (item.tag) {
      case SideSubItemStatus.active:
        changeMain(0);
        changeActive(SideSubItemStatus.active);
        break;
      case SideSubItemStatus.waiting:
        changeMain(1);
        changeActive(SideSubItemStatus.waiting);
        break;
      case SideSubItemStatus.paused:
        changeMain(2);
        changeActive(SideSubItemStatus.paused);
        break;
      case SideSubItemStatus.complete:
        changeMain(3);
        changeActive(SideSubItemStatus.complete);
        break;
      case SideSubItemStatus.setting:
        changeMain(0);
        changeActive(SideSubItemStatus.setting);
        break;
      case SideSubItemStatus.about:
        changeMain(1);
        changeActive(SideSubItemStatus.about);
        break;
    }
  }

  //切换活动页
  void changeActive(String status) {
    for (var i in pInf.sideItem) {
      for (var j in i.subItems) {
        if (j.tag != status) {
          j.isSelect = false;
        } else {
          j.isSelect = true;
        }
      }
    }
  }
}
