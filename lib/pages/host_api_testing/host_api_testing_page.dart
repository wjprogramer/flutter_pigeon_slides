import 'package:flutter/material.dart';

class HostApiTestingPage extends StatelessWidget {
  const HostApiTestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HostApi 測試介紹')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '為什麼要測試 HostApi？',
            children: [
              const Text(
                'HostApi 是 Pigeon 生成的原生端 API 介面，測試它可以確保：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              _BulletPoint('', [
                '介面定義正確',
                '參數傳遞正確',
                '返回值處理正確',
                '錯誤處理正確',
                '型別轉換正確',
              ]),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '測試策略',
            children: [
              const Text(
                'Pigeon 生成的 HostApi 內部使用 BasicMessageChannel，測試方式有幾種：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _StrategyCard(
                title: '方法 1：測試 CounterChannels 的包裝邏輯',
                description: '推薦方式，因為 CounterChannels 已經提供了統一的接口',
                pros: ['測試實際使用的接口', '不需要深入了解 Pigeon 內部實現', '更接近真實使用場景'],
                example: '''// 使用 TestDefaultBinaryMessengerBinding 設置 mock
binding.defaultBinaryMessenger.setMockMethodCallHandler(
  const MethodChannel('demo.counter.method'),
  (MethodCall methodCall) async {
    if (methodCall.method == 'getCounter') {
      return {'value': 42, 'updatedAt': 1234567890};
    }
    return null;
  },
);

final channels = CounterChannels();
final counter = await channels.mcGetCounter();''',
              ),
              const SizedBox(height: 16),
              _StrategyCard(
                title: '方法 2：使用 TestBinaryMessenger 直接測試 HostApi',
                description: '需要設置正確的 channel 名稱和編碼格式',
                pros: ['直接測試 Pigeon 生成的 API', '可以測試更底層的行為'],
                cons: ['需要了解 Pigeon 內部的 channel 命名規則', '需要正確設置編碼格式'],
                example: '''// 設置 Pigeon 使用的 BasicMessageChannel
final testMessenger = TestDefaultBinaryMessengerBinding
    .instance.defaultBinaryMessenger;

testMessenger.setMockMessageHandler(
  'dev.flutter.pigeon.flutter_pigeon_slides.CounterHostApi.getCounter',
  (message) async {
    final codec = const StandardMessageCodec();
    final counter = Counter(value: 100, updatedAt: 1234567890);
    return codec.encodeMessage([counter]);
  },
);

final api = CounterHostApi(binaryMessenger: testMessenger);
final counter = await api.getCounter();''',
              ),
              const SizedBox(height: 16),
              _StrategyCard(
                title: '方法 3：整合測試（Integration Test）',
                description: '使用實際的原生實作進行測試',
                pros: ['最接近真實場景', '測試完整的端到端流程', '可以發現整合問題'],
                cons: ['需要實際的原生實作', '執行時間較長'],
                example: '''// integration_test/counter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Counter 整合測試', (WidgetTester tester) async {
    // 測試實際的原生實作
    final channels = CounterChannels();
    final counter = await channels.pigeonGetCounter();
    expect(counter.value, greaterThanOrEqualTo(0));
  });
}''',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '實際範例：測試 CounterHostApi',
            children: [
              const Text(
                '以下是一個完整的測試範例，展示如何測試 HostApi：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _CodeBlock(
                title: '完整的測試範例',
                code: '''import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pigeon_slides/counter_channels.dart';

void main() {
  // 初始化 Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CounterHostApi 測試', () {
    late TestDefaultBinaryMessengerBinding binding;

    setUp(() {
      binding = TestDefaultBinaryMessengerBinding.instance;
    });

    tearDown(() {
      // 清理 mock handlers
      binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('demo.counter.method'),
        null,
      );
    });

    test('pigeonGetCounter 應該返回正確的 Counter', () async {
      // 設置 mock handler
      binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('demo.counter.method'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getCounter') {
            return {'value': 42, 'updatedAt': 1234567890};
          }
          return null;
        },
      );

      final channels = CounterChannels();
      final counter = await channels.pigeonGetCounter();

      expect(counter.value, 42);
      expect(counter.updatedAt, 1234567890);
    });
  });
}''',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '依賴注入與測試隔離',
            children: [
              const Text(
                'CounterChannels 支援依賴注入，這讓測試變得更容易：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '關鍵優勢',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• 測試使用 mock channels，不會影響實際的原生實作\n'
                        '• 效能測試使用實際實作，不會被測試影響\n'
                        '• 兩者完全隔離，互不干擾\n'
                        '• 可以針對不同場景使用不同的測試策略',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _CodeBlock(
                title: '依賴注入範例',
                code: '''// 測試環境：使用 mock
const testChannel = MethodChannel('test.counter.method');
final testChannels = CounterChannels(methodChannel: testChannel);

// 效能測試環境：使用實際實作
final perfChannels = CounterChannels(); // 使用默認實作

// 兩者使用不同的實例，完全隔離''',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '測試注意事項',
            children: [
              _BulletPoint('初始化 Binding', [
                '必須在測試開始時調用 TestWidgetsFlutterBinding.ensureInitialized()',
                '這是測試 MethodChannel 所必需的',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('清理資源', [
                '在 tearDown 中清理 mock handlers',
                '避免測試之間互相影響',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('異步測試', ['使用 await 等待異步操作完成', '確保測試結果正確']),
              const SizedBox(height: 12),
              _BulletPoint('錯誤處理', ['測試錯誤情況（如 null 返回值、異常等）', '確保錯誤處理邏輯正確']),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint(this.title, this.points);

  final String title;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        if (title.isNotEmpty) const SizedBox(height: 8),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(point, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.title,
    required this.description,
    required this.example,
    this.pros,
    this.cons,
  });

  final String title;
  final String description;
  final List<String>? pros;
  final List<String>? cons;
  final String example;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 16)),
            if (pros != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '優點',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...pros!.map(
                (pro) => Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 4),
                  child: Text('• $pro', style: const TextStyle(fontSize: 14)),
                ),
              ),
            ],
            if (cons != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.info, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    '注意事項',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...cons!.map(
                (con) => Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 4),
                  child: Text('• $con', style: const TextStyle(fontSize: 14)),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '範例：',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    example,
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
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
