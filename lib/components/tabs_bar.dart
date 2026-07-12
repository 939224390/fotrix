import 'package:flutter/material.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/store/task_list.dart';
import 'package:fotrix/components/common.dart';
import 'package:fotrix/utils/theme.dart';
import 'package:signals/signals_flutter.dart';

class TabsBar extends StatefulWidget {
  const TabsBar({super.key, required this.data, required this.onTap});

  final PageInfo data;
  final dynamic Function(TabItem item) onTap;

  @override
  State<TabsBar> createState() => _TabsBarState();
}

class _TabsBarState extends State<TabsBar> {
  static const _animationDuration = Duration(milliseconds: 120);

  late final listLen = computed(
    () => [
      taskList.totalList.length,
      taskList.active.length,
      taskList.waiting.length,
      taskList.complete.length,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (_) => _buildTabBar(
        itemBuilder: (sideItem) {
          return [
            //侧边标题
            _tabBarTitle(sideItem.title),
            SizedBox(height: 30),
            //侧边子列表
            _buildTabs(
              sideItem,
              subItemBuilder: (subItem, index) {
                return _buildTab(subItem, () => widget.onTap(subItem), index);
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
    return Column(
      children: itemBuilder(widget.data.tabs[widget.data.tabIndex]),
    );
  }

  Widget _tabBarTitle(String text) {
    return Padding(
      padding: const .only(top: 20),
      child: buildLText(text, context),
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

  Widget _buildTab(TabItem item, Function func, int index) {
    return SignalBuilder(
      builder: (_) => Padding(
        padding: const .only(left: 10, right: 10, bottom: 8),
        child: AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeOutQuart,
          decoration: BoxDecoration(
            color: _getButtonColor(index),
            borderRadius: .circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: func as void Function()?,
              borderRadius: .circular(10),
              child: Padding(
                padding: const .symmetric(horizontal: 14, vertical: 9),
                child: Row(
                  children: [
                    Icon(item.icon, size: 18, color: context.textColor),
                    SizedBox(width: 6),
                    Expanded(child: buildText(item.title, context)),
                    if (widget.data.tabIndex == 0)
                      buildText(listLen.value[index].toString(), context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(int index) {
    return widget.data.mainIndex == index
        ? context.tabActiveColor
        : context.tabDefaultColor;
  }
}
