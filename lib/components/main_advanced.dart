import 'package:flutter/material.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/utils/common.dart';
import 'package:fotrix/utils/theme.dart';

class MainAdvanced extends StatefulWidget {
  const MainAdvanced({super.key});

  @override
  State<MainAdvanced> createState() => _MainAdvancedState();
}

class _MainAdvancedState extends State<MainAdvanced> {
  bool aria2Log = config.enableAria2Log;
  TextEditingController portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() {
    setState(() {
      aria2Log = config.enableAria2Log;
      portController.text = config.port.toString();
    });
  }

  void _updateState() {
    setState(() {
      config.enableAria2Log = aria2Log;
      config.port = int.parse(portController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildMainTitle("高级设置", context),
        buildDivider(),
        _buildSettingList([
          _buildAria2LogSwitch(),
          _buildPort(),
        ], _buildSaveCanelButton()),
      ],
    );
  }

  Widget _buildAria2LogSwitch() {
    return Row(
      children: [
        _buildSec("开启Aria2日志"),
        Switch(
          inactiveTrackColor: context.switchColor,
          value: aria2Log,
          onChanged: (value) {
            setState(() {
              aria2Log = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPort() {
    return Row(
      children: [
        _buildSec("Aria2端口:"),
        Expanded(
          child: TextField(
            controller: portController,
            decoration: InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.number,
            style: TextStyle(color: context.textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSec(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: buildText(text, context),
    );
  }

  Widget _buildSettingList(List<Widget> children, Widget child) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Column(children: children), child],
      ),
    );
  }

  Widget _buildSaveCanelButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildSaveButton(), _buildCancelButton()],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: context.buttonColor),
        onPressed: () {
          _updateState();
          config.saveConfigBox();
        },
        child: Text("保存"),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: context.buttonColor),
        onPressed: () {
          setState(() {
            _initState();
          });
        },
        child: Text("取消"),
      ),
    );
  }
}
