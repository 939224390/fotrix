import 'package:flutter/material.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:fotrix/utils/common.dart';
import 'package:fotrix/utils/theme.dart';
import 'package:signals/signals_flutter.dart';

class TabsBar extends StatelessWidget {
  TabsBar({super.key, required this.data, required this.onTap});

  final PageInfo data;
  final dynamic Function(TabItem item) onTap;

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
      (_) => _buildTabBar(
        itemBuilder: (sideItem) {
          return [
            //侧边标题
            _buildTabBarTitle(sideItem.title, context),
            SizedBox(height: 30),
            //侧边子列表
            _buildTabs(
              sideItem,
              subItemBuilder: (subItem, index) {
                return _buildTab(subItem, () => onTap(subItem), index, context);
              },
            ),
          ];
        },
      ),
    );
  }

  Widget _buildTabBar({
    required List<Widget> Function(TabsItem item) itemBuilder,
  }) {
    return Column(children: itemBuilder(data.tabs[pInf.pInd]));
  }

  Widget _buildTabBarTitle(String text, BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: buildLText(text, ctx),
    );
  }

  Widget _buildTabs(
    TabsItem item, {
    required Widget Function(TabItem item, int index) subItemBuilder,
  }) {
    return Column(
      children: List.generate(item.tabItems.length, (index) {
        return subItemBuilder(item.tabItems[index], index);
      }),
    );
  }

  Widget _buildTab(TabItem item, Function func, int index, BuildContext ctx) {
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
              pInf.pInd == 0
                  ? buildText(listLen.value[index].toString(), ctx)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(BuildContext context, int index) {
    final theme = context;
    return pInf.mInd == index ? theme.tabActiveColor : theme.tabDefaultColor;
  }
}
