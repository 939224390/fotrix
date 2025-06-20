import 'package:flutter/material.dart';
import 'package:fotrix/models/tray_service.dart';
import 'package:window_manager/window_manager.dart';

class WindowControl extends StatefulWidget {
  const WindowControl({super.key, required this.mode});
  final String mode;

  @override
  State<WindowControl> createState() => _WindowControlState();
}

class _WindowControlState extends State<WindowControl> {
  bool _isMaximized = false;
  @override
  Widget build(BuildContext context) {
    if (widget.mode == "ctrl") {
      return Row(children: [Expanded(child: _buildDragBar()), _buildCtrlBar()]);
    } else {
      return _buildDragBar();
    }
  }

  Widget _buildCtrlBar() {
    return Row(
      children: [
        WindowCaptionButton.minimize(onPressed: () => windowManager.minimize()),
        WindowCaptionButton.maximize(
          onPressed:
              () => {
                setState(() {
                  _isMaximized = !_isMaximized;
                }),
                if (!_isMaximized)
                  {windowManager.unmaximize()}
                else
                  {windowManager.maximize()},
              },
        ),
        WindowCaptionButton.close(
          onPressed: () {
            ts.handleWindowClose();
            windowManager.hide();
          },
        ),
      ],
    );
  }

  Widget _buildDragBar() {
    return DragToMoveArea(
      child: SizedBox(height: 35, width: MediaQuery.of(context).size.width),
    );
  }
}
