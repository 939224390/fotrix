import 'package:flutter/material.dart';

class PageInfo with ChangeNotifier {
  // 分类索引
  int _pInd = 0;
  // 主页面索引
  int _mInd = 0;

  List<String> sideTitle = ["任务列表", "设置"];
  List<List<String>> sideBtn = [
    ["下载中", "等待中", "已暂停", "已完成"],
    ["设置", "关于"],
  ];
  List<List> sideBtnIcon = [
    [Icons.play_arrow, Icons.stop, Icons.pause, Icons.download_done],
    [Icons.settings, Icons.report],
  ];

  int get pInd => _pInd;
  int get mInd => _mInd;

  set pInd(int v) {
    _pInd = v;
    notifyListeners();
  }

  set mInd(int v) {
    _mInd = v;
    notifyListeners();
  }

  void reflesh() {
    notifyListeners();
  }
}

PageInfo pageInfo = PageInfo();
