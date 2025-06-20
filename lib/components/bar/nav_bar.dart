import 'package:flutter/material.dart';
import 'package:fotrix/components/add_task.dart';
import 'package:fotrix/models/config.dart';
import 'package:fotrix/models/page_info.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  void changePage(int p, int m) {
    pageInfo.pInd = p;
    pageInfo.mInd = m;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageInfo, Config>(
      builder: (context, pageInfo, config, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                _buildButton(Icons.home, () => changePage(0, 0)),
                _buildButton(Icons.menu, () => changePage(0, 0)),
                _buildButton(
                  Icons.add,
                  () => showDialog(
                    context: context,
                    builder: (context) => AddTask(),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _buildButton(
                  config.darkMode ? Icons.light_mode : Icons.dark_mode,
                  () => config.toggleTheme(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildButton(Icons.settings, () => changePage(1, 0)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton(IconData icon, VoidCallback func) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: IconButton(
        icon: Icon(icon, size: 30, color: Colors.white),
        onPressed: func,
      ),
    );
  }
}
