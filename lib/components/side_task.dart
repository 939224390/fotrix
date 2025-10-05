import 'package:flutter/material.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:fotrix/utils/common.dart';
import 'package:fotrix/utils/theme.dart';
import 'package:signals/signals_flutter.dart';

class SideTask extends StatelessWidget {
  SideTask({super.key, required this.data, required this.onTap});

  final PageInfo data;
  final dynamic Function(SideSubItemInfo item) onTap;

  late final listLen = computed(
    () => [
      taskList.active.length,
      taskList.waiting.length,
      taskList.complete.length,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) => _buildSide(
        itemBuilder: (sideItem) {
          return [
            //侧边标题
            _buildSideTitle(sideItem.title, context),
            SizedBox(height: 30),
            //侧边子列表
            _buildSideSubList(
              sideItem,
              subItemBuilder: (subIdex, index) {
                return _buildSideButton(
                  subIdex,
                  () => onTap(subIdex),
                  index,
                  context,
                );
              },
            ),
          ];
        },
      ),
    );
  }

  Widget _buildSide({
    required List<Widget> Function(SideItemInfo item) itemBuilder,
  }) {
    return Column(children: itemBuilder(data.sideItem[0]));
  }

  Widget _buildSideTitle(String text, BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: buildLText(text, ctx),
    );
  }

  Widget _buildSideSubList(
    SideItemInfo item, {
    required Widget Function(SideSubItemInfo item, int index) subItemBuilder,
  }) {
    return Column(
      children: List.generate(item.subItems.length, (index) {
        return subItemBuilder(item.subItems[index], index);
      }),
    );
  }

  Widget _buildSideButton(
    SideSubItemInfo item,
    Function func,
    int index,
    BuildContext ctx,
  ) {
    return Watch(
      (_) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          onPressed: func as void Function()?,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(ctx, index),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            side: BorderSide.none,
          ),
          child: Row(
            children: [
              buildIcon(item.icon, ctx),
              buildText(item.title, ctx),
              SizedBox(width: 5),
              buildText(listLen.value[index].toString(), ctx),
            ],
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(BuildContext context, int index) {
    final theme = Theme.of(context).fTheme;
    return pInf.mInd == index ? theme.tabActive : theme.tabDefault;
  }
}
