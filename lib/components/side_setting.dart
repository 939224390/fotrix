import 'package:flutter/material.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/utils/common.dart';
import 'package:signals/signals_flutter.dart';

class SideSetting extends StatelessWidget {
  const SideSetting({super.key, required this.data, required this.onTap});

  final PageInfo data;
  final dynamic Function(SideSubItemInfo item) onTap;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) => _buildSide(
        itemBuilder: (sideItem) {
          return [
            //侧边标题
            _buildSideTitle(sideItem.title),
            SizedBox(height: 30),
            //侧边子列表
            _buildSideSubList(
              sideItem,
              subItemBuilder: (subIdex, index) {
                return _buildSideButton(subIdex, () => onTap(subIdex), index);
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
    return Column(children: itemBuilder(data.sideItem[1]));
  }

  Widget _buildSideTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: buildLText(text),
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

  Widget _buildSideButton(SideSubItemInfo item, Function func, int index) {
    return Watch(
      (_) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          onPressed: func as void Function()?,
          style: ElevatedButton.styleFrom(
            backgroundColor: config.activeColor(index).value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            side: BorderSide.none,
          ),
          child: Row(children: [buildIcon(item.icon), buildText(item.title)]),
        ),
      ),
    );
  }
}
