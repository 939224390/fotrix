import 'package:flutter/material.dart';

class PageInfo with ChangeNotifier {
  // 分类索引
  int _pInd = 0;
  // 主页面索引
  int _mInd = 0;

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
