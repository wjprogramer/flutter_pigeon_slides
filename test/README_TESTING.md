# 測試指南

## 如何測試 Pigeon HostApi 和 MethodChannel

### 1. MethodChannel 測試

**重要**：在測試中必須先初始化 Flutter binding，然後使用 `TestDefaultBinaryMessengerBinding` 來設置 mock handler：

```dart
void main() {
  // 初始化 Flutter binding，這是測試 MethodChannel 所必需的
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CounterChannels 測試', () {
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

    test('mcGetCounter 測試', () async {
      // 使用 TestDefaultBinaryMessengerBinding 設置 mock handler
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
      final counter = await channels.mcGetCounter();

      expect(counter.value, 42);
      expect(counter.updatedAt, 1234567890);
    });
  });
}
```

### 2. Pigeon HostApi 測試

Pigeon 生成的 `CounterHostApi` 內部使用 `BasicMessageChannel`，測試方式：

#### 方法 1: 使用 TestBinaryMessenger

```dart
final testMessenger = TestDefaultBinaryMessengerBinding
    .instance.defaultBinaryMessenger;

// 設置 mock handler
testMessenger.setMockMessageHandler(
  'dev.flutter.pigeon.flutter_pigeon_slides.CounterHostApi.getCounter',
  (message) async {
    final codec = const StandardMessageCodec();
    final counter = Counter(value: 100, updatedAt: 1234567890);
    return codec.encodeMessage([counter]);
  },
);

final api = CounterHostApi(binaryMessenger: testMessenger);
final counter = await api.getCounter();
```

#### 方法 2: 測試 CounterChannels 的包裝邏輯

由於 `CounterChannels` 已經提供了統一的接口，可以測試這個接口：

```dart
final channels = CounterChannels(pigeonApi: mockApi);
final counter = await channels.pigeonGetCounter();
```

### 3. 依賴注入

`CounterChannels` 支援依賴注入，可以在測試中注入 mock 實例：

```dart
// 測試環境：使用 mock
final testChannel = const MethodChannel('test.counter.method');
final testChannels = CounterChannels(methodChannel: testChannel);

// 效能測試環境：使用實際實作
final perfChannels = CounterChannels(); // 使用默認實作
```

### 4. 測試與效能測試的隔離

**重要**：測試不會影響 `AutoTestPage` 的效能測試，因為：

1. **不同的實例**：測試使用注入的 mock channels，效能測試使用默認的實際 channels
2. **不同的 channel 名稱**：測試可以使用不同的 channel 名稱，完全隔離
3. **不同的 BinaryMessenger**：Pigeon API 可以注入不同的 BinaryMessenger

### 5. 執行測試

```bash
# 執行所有測試
flutter test

# 執行特定測試文件
flutter test test/counter_channels_test.dart

# 執行測試並查看覆蓋率
flutter test --coverage
```

### 6. 整合測試

對於更完整的測試，建議使用整合測試（Integration Test）：

```dart
// integration_test/counter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Counter 整合測試', (WidgetTester tester) async {
    // 測試實際的原生實作
  });
}
```

執行整合測試：
```bash
flutter test integration_test
```

## 注意事項

1. **測試隔離**：確保測試使用的 channels 與效能測試使用的 channels 不同
2. **清理資源**：在 `tearDown` 中清理 mock handlers
3. **異步測試**：使用 `await` 等待異步操作完成
4. **錯誤處理**：測試錯誤情況（如 null 返回值、異常等）

