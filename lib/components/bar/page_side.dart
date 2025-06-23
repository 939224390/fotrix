import 'package:flutter/material.dart';
import 'package:fotrix/models/task_list.dart';
import 'package:fotrix/utils/common.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/models/page_info.dart';
import 'package:provider/provider.dart';

class PageSide extends StatefulWidget {
  const PageSide({super.key});

  @override
  State<PageSide> createState() => _PageSideState();
}

class _PageSideState extends State<PageSide> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<Config, PageInfo, TaskList>(
      builder: (context, config, pageInfo, taskList, child) {
        return Column(
          children: [
            buildSideTitle(pageInfo.sideTitle[pageInfo.pInd]),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  for (
                    int i = 0;
                    i < (pageInfo.sideBtn[pageInfo.pInd].length);
                    i++
                  )
                    _buildSideButton(
                      i,
                      pageInfo.sideBtn[pageInfo.pInd][i],
                      pageInfo.sideBtnIcon[pageInfo.pInd][i],
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

  Widget _buildSideButton(
    int index,
    String text,
    IconData icon,
    Function func,
  ) {
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
  }
}
