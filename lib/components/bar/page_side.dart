import 'package:flutter/material.dart';
import 'package:fotrix/components/common/common.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/models/page_info.dart';
import 'package:provider/provider.dart';

class PageSide extends StatefulWidget {
  const PageSide({super.key});

  @override
  State<PageSide> createState() => _PageSideState();
}

class _PageSideState extends State<PageSide> {
  List<String> title = ["任务列表", "设置"];
  List<List<String>> btnTitle = [
    ["下载中", "已暂停", "已完成"],
    ["设置", "关于"],
  ];
  List<List> btnIcon = [
    [Icons.play_arrow, Icons.pause, Icons.download_done],
    [Icons.settings, Icons.report],
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<PageInfo>(
      builder: (context, pageInfo, child) {
        return Column(
          children: [
            _buildSideTitle(title[pageInfo.pInd]),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  for (int i = 0; i < (btnTitle[pageInfo.pInd].length); i++)
                    _buildSideButton(
                      i,
                      btnTitle[pageInfo.pInd][i],
                      btnIcon[pageInfo.pInd][i],
                      () => pageInfo.mInd = i,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSideTitle(String text) {
    return Consumer<Config>(
      builder: (context, config, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            text,
            style: TextStyle(color: config.getColor("text"), fontSize: 20),
          ),
        );
      },
    );
  }

  Widget _buildSideButton(
    int index,
    String text,
    IconData icon,
    Function func,
  ) {
    return Consumer<Config>(
      builder: (context, config, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            onPressed: func as void Function()?,
            style: ElevatedButton.styleFrom(
              backgroundColor: config.currActiveColor(pageInfo.mInd, index),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              side: BorderSide.none,
            ),
            child: Row(
              children: [
                Row(children: [buildIcon(icon), buildText(text)]),
              ],
            ),
          ),
        );
      },
    );
  }
}
