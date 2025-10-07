import 'package:flutter/material.dart';
import 'package:fotrix/store/page_info.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.data, required this.onTap});

  final PageInfo data;
  final dynamic Function(NavItem item) onTap;

  @override
  Widget build(BuildContext context) {
    //左侧导航栏
    return _buildNavgation([
      //上部分按钮
      _buildTopItem(),
      //下部分按钮
      _buildBottomItem(),
    ]);
  }

  Widget _buildNavgation(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  Widget _buildTopItem() {
    return Column(
      children: List.generate(
        data.navTop.length,
        (index) => _buildButton(
          data.navTop[index].icon,
          () => onTap(data.navTop[index]),
        ),
      ),
    );
  }

  Widget _buildBottomItem() {
    return Column(
      children: List.generate(
        data.navBtm.length,
        (index) => _buildButton(
          data.navBtm[index].icon,
          () => onTap(data.navBtm[index]),
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback func) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: IconButton(
        icon: Icon(icon, size: 30, color: Colors.white),
        onPressed: func,
      ),
    );
  }
}
