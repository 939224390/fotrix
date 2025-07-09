import 'package:flutter/material.dart';
import 'package:fotrix/components/add_task.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/store/task_list.dart';

class FotrixLogic {
  PageInfo state = PageInfo();
  late BuildContext context;

  void init(BuildContext context) {
    this.context = context;
  }

  void resumeAllTask(){
    taskList.resumeAll();
  }

  void stopAllTask(){
    taskList.stopAll();
  }

  void navigationLogic(NavBarItemInfo item) {
    switch (item.tag) {
      case NavBarItemStatus.home:
        pageInfo.changePage(0);
        changeActive(SideSubItemStatus.active);
        break;
      case NavBarItemStatus.list:
        pageInfo.changePage(0);
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
        pageInfo.changePage(1);
        break;
    }
  }

  void sideLogic(SideSubItemInfo item) {
    switch (item.tag) {
      case SideSubItemStatus.active:
        pageInfo.changeMain(0);
        changeActive(SideSubItemStatus.active);
        break;
      case SideSubItemStatus.waiting:
        pageInfo.changeMain(1);
        changeActive(SideSubItemStatus.waiting);
        break;
      case SideSubItemStatus.paused:
        pageInfo.changeMain(2);
        changeActive(SideSubItemStatus.paused);
        break;
      case SideSubItemStatus.complete:
        pageInfo.changeMain(3);
        changeActive(SideSubItemStatus.complete);
        break;
      case SideSubItemStatus.setting:
        pageInfo.changeMain(0);
        changeActive(SideSubItemStatus.setting);
        break;
      case SideSubItemStatus.about:
        pageInfo.changeMain(1);
        changeActive(SideSubItemStatus.about);
        break;
    }
  }

  //切换活动页
  void changeActive(String status) {
    for (var i in state.sideItem) {
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
