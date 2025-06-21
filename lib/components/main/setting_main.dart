import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fotrix/components/common/common.dart';
import 'package:fotrix/models/config.dart';
import 'package:provider/provider.dart';

class SettingMain extends StatefulWidget {
  const SettingMain({super.key});

  @override
  State<SettingMain> createState() => _SettingMainState();
}

class _SettingMainState extends State<SettingMain> {
  final TextEditingController _thCtrler = TextEditingController();
  String _tmpPath = config.savePath;
  bool pb = config.powerBoot;
  @override
  void initState() {
    super.initState();
    _initialValues();
  }

  void _initialValues() async {
    _thCtrler.text = config.threadCount.toString();
    _tmpPath = config.savePath;
    pb = config.powerBoot;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (context, config, child) {
        return Column(
          children: [
            buildTitle("设置"),
            buildDivider(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildSec("开机自启"),
                          Switch(
                            value: pb,
                            onChanged: (v) {
                              setState(() {
                                pb = !pb;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildSec("下载线程(1-64):"),
                          Expanded(
                            child: TextField(
                              controller: _thCtrler,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildSec("保存路径"),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: config.getColor("main"),
                                elevation: 0,
                                side: BorderSide.none,
                              ),
                              onPressed: _selectDirectory,
                              child: Text(_tmpPath),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              config.threadCount = int.parse(_thCtrler.text);
                              setState(() {
                                _thCtrler.text = config.threadCount.toString();
                                config.savePath = _tmpPath;
                                config.powerBoot = pb;
                              });
                              final snackBar = SnackBar(content: Text("内容已保存"));
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                              config.saveConfig();
                            },
                            child: Text("保存"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _thCtrler.text = config.threadCount.toString();
                                _tmpPath = config.savePath;
                                pb = config.powerBoot;
                              });
                            },
                            child: Text("取消"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSec(String text) {
    return Padding(padding: const EdgeInsets.all(12), child: buildText(text));
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
