import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/app_scale.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _scale = appScale.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('App 縮放（僅影響 Menu/非簡報頁）'),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('0.8x'),
                Expanded(
                  child: Slider(
                    value: _scale,
                    min: 0.8,
                    max: 1.8,
                    divisions: 10,
                    label: '${_scale.toStringAsFixed(2)}x',
                    onChanged: (v) {
                      setState(() {
                        _scale = v;
                        appScale.value = v;
                      });
                    },
                  ),
                ),
                const Text('1.8x'),
              ],
            ),
            const SizedBox(height: 8),
            Text('當前：${_scale.toStringAsFixed(2)}x'),
            const SizedBox(height: 16),
            const Text(
                '說明：此縮放僅套用在 Menu/效能/DEMO 等非簡報頁面，避免影響簡報主體。'),
          ],
        ),
      ),
    );
  }
}

