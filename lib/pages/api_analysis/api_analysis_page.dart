import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/pages/api_doc/api_doc_page.dart';

class ApiAnalysisPage extends StatelessWidget {
  const ApiAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pigeon API 分析'),
        actions: [
          IconButton(
            icon: const Icon(Icons.description),
            tooltip: '查看完整 API 文件',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ApiDocPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.insights, color: Colors.blue, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'API 總覽',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getDarkerColor(Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ApiDocPage(),
                              ),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Pigeon 的 API 數量很少，大部分是平台選項配置。'
                                  '實際上需要學習的核心 API 非常少，這讓學習曲線變得平緩。',
                              style: const TextStyle(fontSize: 16),
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.open_in_new,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _CategorySection(
            title: '⭐ 核心 API（必須學習）',
            subtitle: '這些是使用 Pigeon 的基礎，幾乎每個專案都會用到',
            color: Colors.orange,
            items: [
              _ApiItem(
                name: '@ConfigurePigeon',
                description: '配置 Pigeon 生成選項，定義輸出路徑和平台選項',
                importance: '必須',
                example: '@ConfigurePigeon(\n  PigeonOptions(...)\n)',
              ),
              _ApiItem(
                name: '@HostApi()',
                description: '定義由原生平台實作的 API（Flutter 呼叫原生）',
                importance: '必須',
                example: '@HostApi()\nabstract class DeviceApi {\n  DeviceInfo getDeviceInfo();\n}',
              ),
              _ApiItem(
                name: '@FlutterApi()',
                description: '定義由 Flutter 實作的 API（原生呼叫 Flutter）',
                importance: '常用',
                example: '@FlutterApi()\nabstract class CounterFlutterApi {\n  void onCounter(Counter counter);\n}',
              ),
              _ApiItem(
                name: '@EventChannelApi()',
                description: '定義事件通道 API（用於串流資料）',
                importance: '常用',
                example: '@EventChannelApi()\nabstract class CounterEventApi {\n  Counter watch();\n}',
              ),
              _ApiItem(
                name: 'PigeonOptions',
                description: 'Pigeon 的配置選項，包含輸出路徑、套件名稱等',
                importance: '必須',
                example: 'PigeonOptions(\n  dartOut: \'lib/pigeon/messages.dart\',\n  kotlinOut: \'...\',\n)',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _CategorySection(
            title: '📦 資料型別（常用）',
            subtitle: '定義資料結構時使用，大部分是 Dart 基本型別',
            color: Colors.green,
            items: [
              _ApiItem(
                name: '基本型別',
                description: 'int, String, bool, double, List, Map 等 Dart 基本型別',
                importance: '必須',
                example: 'class DeviceInfo {\n  String model;\n  int version;\n}',
              ),
              _ApiItem(
                name: 'Uint8List',
                description: '8 位元無符號整數列表（用於二進位資料）',
                importance: '按需',
                example: 'Uint8List imageData;',
              ),
              _ApiItem(
                name: 'Int32List / Int64List',
                description: '32/64 位元整數列表',
                importance: '按需',
                example: 'Int32List values;',
              ),
              _ApiItem(
                name: 'Float64List',
                description: '64 位元浮點數列表',
                importance: '按需',
                example: 'Float64List coordinates;',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _CategorySection(
            title: '⚙️ 平台選項（按需使用）',
            subtitle: '大部分 API 都是不同平台的配置選項，不需要全部學習',
            color: Colors.purple,
            items: [
              _ApiItem(
                name: 'KotlinOptions',
                description: 'Kotlin 程式碼生成選項（如 package 名稱）',
                importance: '按需',
                example: 'kotlinOptions: KotlinOptions(\n  package: \'com.example.app\'\n)',
              ),
              _ApiItem(
                name: 'SwiftOptions',
                description: 'Swift 程式碼生成選項',
                importance: '按需',
                example: 'swiftOptions: SwiftOptions()',
              ),
              _ApiItem(
                name: 'JavaOptions / ObjcOptions',
                description: 'Java 或 Objective-C 程式碼生成選項',
                importance: '按需',
                example: 'javaOptions: JavaOptions(...)',
              ),
              _ApiItem(
                name: 'CppOptions / GObjectOptions',
                description: 'C++ 或 GObject 程式碼生成選項（較少使用）',
                importance: '很少用',
                example: 'cppOptions: CppOptions(...)',
              ),
              _ApiItem(
                name: 'KotlinEventChannelOptions',
                description: 'Kotlin EventChannel 的特定選項',
                importance: '按需',
                example: 'kotlinEventChannelOptions: ...',
              ),
              _ApiItem(
                name: 'SwiftEventChannelOptions',
                description: 'Swift EventChannel 的特定選項',
                importance: '按需',
                example: 'swiftEventChannelOptions: ...',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _CategorySection(
            title: '🚀 進階功能（可選）',
            subtitle: '特殊場景才會用到，初學者可以暫時忽略',
            color: Colors.teal,
            items: [
              _ApiItem(
                name: '@ProxyApi',
                description: '定義代理 API（用於複雜的狀態管理場景）',
                importance: '進階',
                example: '@ProxyApi()\nabstract class StateApi {...}',
              ),
              _ApiItem(
                name: '@TaskQueue',
                description: '控制 API handler 的執行佇列',
                importance: '進階',
                example: '@TaskQueue(TaskQueueType.serialBackgroundThread)',
              ),
              _ApiItem(
                name: '@SwiftClass / @SwiftFunction',
                description: '控制 Swift 程式碼生成的特定格式',
                importance: '很少用',
                example: '@SwiftClass()\nclass MyData {...}',
              ),
              _ApiItem(
                name: '@ObjCSelector',
                description: '控制 Objective-C 的 selector 名稱',
                importance: '很少用',
                example: '@ObjCSelector(\'divideValue:by:\')',
              ),
              _ApiItem(
                name: '@async / @static / @attached',
                description: '元數據註解，用於特殊場景',
                importance: '很少用',
                example: '@async\nFuture<void> doSomething();',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _CategorySection(
            title: '🛠️ 工具類（開發時使用）',
            subtitle: '主要在開發和除錯時使用，一般使用者不需要深入了解',
            color: Colors.grey,
            items: [
              _ApiItem(
                name: 'Pigeon',
                description: 'Pigeon 工具類（用於程式化生成）',
                importance: '很少用',
                example: 'Pigeon.generate(...)',
              ),
              _ApiItem(
                name: 'Error / ParseResults',
                description: '錯誤處理和解析結果（用於除錯）',
                importance: '很少用',
                example: 'ParseResults results = ...',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        '學習建議',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1. 先掌握核心 API（@ConfigurePigeon, @HostApi, @FlutterApi）\n'
                    '2. 了解基本資料型別的使用\n'
                    '3. 根據專案需求學習對應平台的選項（如只需要 Android，就學 KotlinOptions）\n'
                    '4. 進階功能等有需要時再學習\n'
                    '5. 大部分平台選項都有預設值，不需要全部配置',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.items,
  });

  final String title;
  final String subtitle;
  final Color color;
  final List<_ApiItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getDarkerColor(color),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _ApiItemCard(item: item)),
      ],
    );
  }
}

class _ApiItemCard extends StatelessWidget {
  const _ApiItemCard({required this.item});

  final _ApiItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            _ImportanceBadge(item.importance),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item.description,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '範例：',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.example,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiItem {
  const _ApiItem({
    required this.name,
    required this.description,
    required this.importance,
    required this.example,
  });

  final String name;
  final String description;
  final String importance;
  final String example;
}

class _ImportanceBadge extends StatelessWidget {
  const _ImportanceBadge(this.importance);

  final String importance;

  Color get _color {
    switch (importance) {
      case '必須':
        return Colors.red;
      case '常用':
        return Colors.orange;
      case '按需':
        return Colors.blue;
      case '進階':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        importance,
        style: TextStyle(
          color: _getDarkerColor(_color),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Color _getDarkerColor(Color color) {
  return Color.fromRGBO(
    (color.red * 0.7).round().clamp(0, 255),
    (color.green * 0.7).round().clamp(0, 255),
    (color.blue * 0.7).round().clamp(0, 255),
    1.0,
  );
}

