import 'package:flutter/material.dart';
import 'package:fotrix/store/page_info.dart';
import 'package:fotrix/utils/tray_service.dart';
import 'package:tray_manager/tray_manager.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.data, required this.onTap});

  final PageInfo data;
  final dynamic Function(NavItem item) onTap;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconRightMouseDown() {
    ts.mouseRightDown();
  }

  @override
  void onTrayIconMouseDown() {
    ts.onTrayIconClick();
  }

  @override
  Widget build(BuildContext context) {
    ts.updateContext(context);
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
        widget.data.navTop.length,
        (index) => _buildButton(
          widget.data.navTop[index].icon,
          () => widget.onTap(widget.data.navTop[index]),
        ),
      ),
    );
  }

  Widget _buildBottomItem() {
    return Column(
      children: List.generate(
        widget.data.navBtm.length,
        (index) => _buildButton(
          widget.data.navBtm[index].icon,
          () => widget.onTap(widget.data.navBtm[index]),
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
