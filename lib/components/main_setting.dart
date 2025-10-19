import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fotrix/utils/common.dart';
import 'package:fotrix/store/config.dart';
import 'package:fotrix/utils/theme.dart';

class MainSetting extends StatefulWidget {
  const MainSetting({super.key});

  @override
  State<MainSetting> createState() => _MainSettingState();
}

class _MainSettingState extends State<MainSetting> {
  final TextEditingController _thCtrler = TextEditingController();
  final TextEditingController _mDCtrler = TextEditingController();
  String _tmpPath = config.savePath;
  bool pb = config.powerBoot;
  @override
  void initState() {
    super.initState();
    _initialValues();
  }

  void _initialValues() {
    setState(() {
      _thCtrler.text = config.threadCount.toString();
      _mDCtrler.text = config.maxDown.toString();
      _tmpPath = config.savePath;
      pb = config.powerBoot;
    });
  }

  void _updateValues() {
    setState(() {
      config.threadCount = int.parse(_thCtrler.text);
      config.maxDown = int.parse(_mDCtrler.text);
      config.savePath = _tmpPath;
      config.powerBoot = pb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildMainTitle("设置", context),
        buildDivider(),
        _buildSettingList([
          _buildPowerBootSwitch(),
          _buildMaxDownload(),
          _buildThCount(),
          _buildSavePath(),
        ], _buildSaveCanelButton()),
      ],
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

  Widget _buildSec(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: buildText(text, context),
    );
  }

  Widget _buildPowerBootSwitch() {
    return Row(
      children: [
        _buildSec("开机自启"),
        Switch(
          inactiveTrackColor: context.switchColor,
          value: pb,
          onChanged: (v) {
            setState(() {
              pb = !pb;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMaxDownload() {
    return Row(
      children: [
        _buildSec("同时最多下载数量:"),
        Expanded(
          child: TextField(
            controller: _mDCtrler,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(border: InputBorder.none),
            style: TextStyle(color: context.textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildThCount() {
    return Row(
      children: [
        _buildSec("下载线程(1-16):"),
        Expanded(
          child: TextField(
            controller: _thCtrler,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(border: InputBorder.none),
            style: TextStyle(color: context.textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSavePath() {
    return Row(
      children: [
        _buildSec("保存路径"),
        Expanded(
          child: _buildSavePathBtn(
            _selectDirectory,
            buildText(_tmpPath, context),
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildSavePathBtn(
    void Function()? onPressed,
    Widget child,
    BuildContext ctx,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ctx.buttonColor,
        elevation: 0,
        side: BorderSide.none,
      ),
      onPressed: onPressed,
      child: child,
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
          _updateValues();
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
            _initialValues();
          });
        },
        child: Text("取消"),
      ),
    );
  }

  Future<void> _selectDirectory() async {
    try {
      String? stDir = await FilePicker.platform.getDirectoryPath();
      if (!mounted) return;
      if (stDir != null && stDir.isNotEmpty) {
        setState(() {
          _tmpPath = stDir;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("选择目录失败: $e")));
    }
  }
}
