import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/widgets/common/code.dart';

/// 測試架構說明頁面
class AutoTestArchitecturePage extends StatelessWidget {
  const AutoTestArchitecturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('測試架構說明')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '測試架構概述',
            children: [
              const Text(
                '自動測試頁面使用批次測試的方式，測量不同通訊方式的效能。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _InfoCard(
                title: '測試流程',
                items: [
                  '每個方法執行 60 個批次，每個批次 2000 次操作',
                  '前 10 個批次為 warm-up，不納入統計',
                  '使用臨時變數收集結果，避免執行過程中的 setState 影響性能',
                  '執行完成後一次性更新 UI',
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '核心測量方法',
            children: [
              const Text(
                '使用 Stopwatch 測量平均微秒數：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              PageCodeBlock(
                code: '''Future<double> _measureAvgMicros(Future<void> Function() op) async {
  final sw = Stopwatch()..start();
  for (var i = 0; i < _batchSize; i++) {
    await op();
  }
  sw.stop();
  return sw.elapsedMicroseconds / _batchSize;
}''',
                language: 'dart',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '測試方法列表',
            children: [
              const Text(
                '測試包含以下通訊方式：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              _MethodCard(
                name: 'MethodChannel',
                code: '''('mc', 'MethodChannel', 
  () => _measureAvgMicros(() => _channels.mcIncrement(1))
)''',
              ),
              const SizedBox(height: 12),
              _MethodCard(
                name: 'MethodChannel (long keys)',
                code: '''('mcLong', 'MethodChannel (long keys)', 
  () => _measureAvgMicros(() => _channels.mcLongIncrement(1))
)''',
              ),
              const SizedBox(height: 12),
              _MethodCard(
                name: 'Pigeon HostApi',
                code: '''('pigeon', 'Pigeon HostApi', 
  () => _measureAvgMicros(() => _channels.pigeonIncrement(1))
)''',
              ),
              const SizedBox(height: 12),
              _MethodCard(
                name: 'BasicMessageChannel',
                code: '''('basic', 'BasicMessageChannel', 
  () => _measureAvgMicros(() => _channels.basicEcho({'v': 1}))
)''',
              ),
              const SizedBox(height: 12),
              _MethodCard(
                name: 'FFI',
                code: '''('ffi', 'FFI', 
  () => _measureAvgMicros(() async => _ffi.increment(1))
)''',
              ),
              const SizedBox(height: 12),
              _MethodCard(
                name: 'Pure Dart (baseline)',
                code: '''('dart', 'Pure Dart (baseline)', 
  () => _measureAvgMicros(() async {
    dartCounter += 1;
  })
)''',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Flutter → 原生測試實作頁面
class FlutterToNativeTestPage extends StatelessWidget {
  const FlutterToNativeTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter → 原生測試實作')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '測試流程',
            children: [
              const Text(
                '測試 Flutter 呼叫原生方法的效能，包含完整的批次執行邏輯：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              PageCodeBlock(
                code: '''Future<void> _runAuto() async {
  if (_running) return;
  
  // 初始化狀態
  setState(() {
    _running = true;
    _status = '準備中...（Flutter → 原生）';
    _mcSeries.clear();
    _pigeonSeries.clear();
    // ... 清除所有數據
  });
  
  await _resetCounters();
  
  // 定義測試操作
  final ops = <(String, String, Future<double> Function())>[
    ('mc', 'MethodChannel', 
      () => _measureAvgMicros(() => _channels.mcIncrement(1))),
    ('pigeon', 'Pigeon HostApi', 
      () => _measureAvgMicros(() => _channels.pigeonIncrement(1))),
    // ... 其他方法
  ];
  
  // 使用臨時變數收集結果，避免執行過程中的 setState 影響性能
  final tempMcSeries = <double>[];
  final tempPigeonSeries = <double>[];
  // ...
  
  // 每個方法連續執行完整的批次
  for (final op in ops) {
    if (!_running) break;
    
    final opKey = op.\$1;
    final opFunc = op.\$3;
    
    for (var batchIdx = 0; batchIdx < _batches && _running; batchIdx++) {
      // 每個批次開始前重置所有狀態
      await _resetCounters();
      
      // 執行該方法的測量（不觸發 setState）
      final result = await opFunc();
      
      if (!_running) break;
      
      // 收集結果到臨時變數（不觸發 setState）
      final include = batchIdx >= _warmup;
      if (include) {
        switch (opKey) {
          case 'mc':
            tempMcSeries.add(result);
            break;
          case 'pigeon':
            tempPigeonSeries.add(result);
            break;
          // ...
        }
      }
      
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
  
  // 執行完成後，一次性更新 UI
  if (mounted && _running) {
    setState(() {
      _mcSeries.addAll(tempMcSeries);
      _pigeonSeries.addAll(tempPigeonSeries);
      // ...
    });
  }
}''',
                language: 'dart',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '關鍵設計',
            children: [
              _BulletPoint('避免 setState 影響性能', [
                '使用臨時變數收集結果',
                '執行過程中不觸發 setState',
                '執行完成後一次性更新 UI',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('批次執行', [
                '每個方法連續執行完整的批次',
                '避免執行順序影響結果',
                '每個批次開始前重置狀態',
              ]),
              const SizedBox(height: 12),
              _BulletPoint('Warm-up 機制', [
                '前 10 個批次為 warm-up',
                '不納入統計結果',
                '確保測試結果的穩定性',
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

/// 原生 → Flutter 測試實作頁面
class NativeToFlutterTestPage extends StatelessWidget {
  const NativeToFlutterTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('原生 → Flutter 測試實作')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '測試方法',
            children: [
              const Text(
                '測試原生主動通知 Flutter 的延遲，包含三種方式：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _MethodCard(
                name: 'EventChannel',
                code: '''Future<double> _measureMethodToFlutter() async {
  _collectMethodEvents = true;
  _expectEvents = _eventBurst;
  _methodBurst.clear();
  _eventCompleter = Completer<void>();
  
  // 觸發原生發送事件
  await _channels.mcEmitEvents(_eventBurst);
  
  // 等待所有事件接收完成
  await _waitOrTimeout(_eventCompleter!);
  
  _collectMethodEvents = false;
  
  // 計算平均延遲
  final avg = _methodBurst.isEmpty
      ? 0.0
      : (_methodBurst.reduce((a, b) => a + b) / _methodBurst.length);
  
  return avg;
}''',
              ),
              const SizedBox(height: 16),
              _MethodCard(
                name: 'Pigeon EventChannelApi',
                code: '''Future<double> _measurePigeonEventToFlutter() async {
  _collectPigeonEvents = true;
  _expectEvents = _eventBurst;
  _pigeonBurst.clear();
  _eventCompleter = Completer<void>();
  
  // 觸發原生發送 Pigeon 事件
  await _channels.pigeonEmitWatchEvents(_eventBurst);
  
  // 等待所有事件接收完成
  await _waitOrTimeout(_eventCompleter!);
  
  _collectPigeonEvents = false;
  
  // 計算平均延遲
  final avg = _pigeonBurst.isEmpty
      ? 0.0
      : (_pigeonBurst.reduce((a, b) => a + b) / _pigeonBurst.length);
  
  return avg;
}''',
              ),
              const SizedBox(height: 16),
              _MethodCard(
                name: 'Pigeon FlutterApi',
                code: '''Future<double> _measurePigeonFlutterApiToFlutter() async {
  _collectPigeonFlutter = true;
  _expectEvents = _eventBurst;
  _pigeonFlutterBurst.clear();
  _eventCompleter = Completer<void>();
  
  // 觸發原生呼叫 FlutterApi
  await _channels.pigeonEmitFlutterEvents(_eventBurst);
  
  // 等待所有事件接收完成
  await _waitOrTimeout(_eventCompleter!);
  
  _collectPigeonFlutter = false;
  
  // 計算平均延遲
  final avg = _pigeonFlutterBurst.isEmpty
      ? 0.0
      : (_pigeonFlutterBurst.reduce((a, b) => a + b) / 
            _pigeonFlutterBurst.length);
  
  return avg;
}''',
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '事件收集機制',
            children: [
              const Text(
                '透過 Stream 監聽事件，計算從原生發送到 Flutter 接收的延遲：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              PageCodeBlock(
                code: '''// 在 initState 中設置事件監聽
_methodEventSub = _channels.events().listen((event) {
  if (!_collectMethodEvents || 
      _methodBurst.length >= _expectEvents) return;
  
  if (event.updatedAt != null) {
    final now = DateTime.now().millisecondsSinceEpoch.toDouble();
    _methodBurst.add(
      (now - event.updatedAt!.toDouble())
          .clamp(0, double.maxFinite),
    );
    
    if (_methodBurst.length >= _expectEvents) {
      _eventCompleter?.complete();
    }
  }
});''',
                language: 'dart',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '批次執行',
            children: [
              PageCodeBlock(
                code: '''Future<void> _runNativeToFlutter() async {
  if (!_running) return;
  
  // 使用臨時變數收集結果
  final tempM2fMethodSeries = <double>[];
  final tempM2fPigeonEventSeries = <double>[];
  final tempM2fPigeonFlutterSeries = <double>[];
  
  for (var i = 0; i < _eventBatches && _running; i++) {
    final m = await _measureMethodToFlutter();
    final pe = await _measurePigeonEventToFlutter();
    final pf = await _measurePigeonFlutterApiToFlutter();
    
    if (!_running) break;
    
    // 收集結果到臨時變數（不觸發 setState）
    final include = i >= _warmup;
    if (include) {
      tempM2fMethodSeries.add(m);
      tempM2fPigeonEventSeries.add(pe);
      tempM2fPigeonFlutterSeries.add(pf);
    }
  }
  
  // 執行完成後，一次性更新 UI
  if (mounted && _running) {
    setState(() {
      _m2fMethodSeries.addAll(tempM2fMethodSeries);
      _m2fPigeonEventSeries.addAll(tempM2fPigeonEventSeries);
      _m2fPigeonFlutterSeries.addAll(tempM2fPigeonFlutterSeries);
    });
  }
}''',
                language: 'dart',
                fontSize: 14.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 原生端實作說明頁面
class NativeImplementationPage extends StatelessWidget {
  const NativeImplementationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('原生端實作')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Android (Kotlin) - MethodChannel Handler',
            children: [
              const Text(
                '在 MainActivity 中設置 MethodChannel 的 handler：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              PageCodeBlock(
                code: '''override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
  super.configureFlutterEngine(flutterEngine)
  val messenger = flutterEngine.dartExecutor.binaryMessenger

  // MethodChannel demo
  val methodChannel = MethodChannel(messenger, "demo.counter.method")
  methodChannel.setMethodCallHandler(::handleMethodCall)
}

private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
  when (call.method) {
    "getCounter" -> result.success(
      makeCounterPayload(methodCounterValue, methodCounterUpdatedAt)
    )
    "increment" -> {
      val delta = (call.argument<Number>("delta") ?: 0).toLong()
      methodCounterValue += delta
      methodCounterUpdatedAt = nowMs()
      result.success(
        makeCounterPayload(methodCounterValue, methodCounterUpdatedAt)
      )
    }
    "reset" -> {
      methodCounterValue = 0
      methodCounterUpdatedAt = nowMs()
      result.success(
        makeCounterPayload(methodCounterValue, methodCounterUpdatedAt)
      )
    }
    "emitMethodEvents" -> {
      val count = (call.argument<Number>("count") ?: 0).toInt()
      emitMethodEvents(count)
      result.success(null)
    }
    else -> result.notImplemented()
  }
}

private fun makeCounterPayload(value: Long, updatedAt: Long): Map<String, Any> =
    mapOf("v" to value, "t" to updatedAt)''',
                language: 'kotlin',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'iOS/macOS (Swift) - MethodChannel Handler',
            children: [
              const Text(
                '在 AppDelegate 中設置 MethodChannel 的 handler：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              PageCodeBlock(
                code: '''func configureChannels(controller: FlutterViewController) {
  let messenger = controller.engine.binaryMessenger

  // MethodChannel demo
  let methodChannel = FlutterMethodChannel(
    name: "demo.counter.method",
    binaryMessenger: messenger
  )
  
  methodChannel.setMethodCallHandler { [weak self] call, result in
    guard let self else { return }
    switch call.method {
    case "getCounter":
      result(self.makeCounterPayload(
        value: self.methodCounterValue, 
        updatedAt: self.methodCounterUpdatedAt
      ))
    case "increment":
      guard let args = call.arguments as? [String: Any],
            let delta = args["delta"] as? Int else {
        result(FlutterError(
          code: "bad-args", 
          message: "Missing delta", 
          details: nil
        ))
        return
      }
      methodCounterValue += Int64(delta)
      methodCounterUpdatedAt = nowMs()
      let payload = makeCounterPayload(
        value: methodCounterValue, 
        updatedAt: methodCounterUpdatedAt
      )
      result(payload)
    case "reset":
      methodCounterValue = 0
      methodCounterUpdatedAt = nowMs()
      let payload = makeCounterPayload(
        value: methodCounterValue, 
        updatedAt: methodCounterUpdatedAt
      )
      result(payload)
    case "emitMethodEvents":
      guard let args = call.arguments as? [String: Any],
            let count = args["count"] as? Int else {
        result(FlutterError(
          code: "bad-args", 
          message: "Missing count", 
          details: nil
        ))
        return
      }
      emitMethodEvents(count: count)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

private func makeCounterPayload(value: Int64, updatedAt: Int64) -> [String: Any] {
  return ["v": value, "t": updatedAt]
}''',
                language: 'swift',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'Android - EventChannel Handler',
            children: [
              const Text(
                'EventChannel 用於原生主動發送事件到 Flutter：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              PageCodeBlock(
                code: '''// EventChannel (hand-written)
val eventChannel = EventChannel(messenger, "demo.counter.events")
eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    methodEventSink = events
  }

  override fun onCancel(arguments: Any?) {
    methodEventSink = null
  }
})

// 發送事件
private fun emitMethodEvents(count: Int) {
  if (count <= 0) return
  val payload = makeCounterPayload(methodCounterValue, nowMs())
  repeat(count) { methodEventSink?.success(payload) }
}''',
                language: 'kotlin',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'iOS/macOS - EventChannel Handler',
            children: [
              PageCodeBlock(
                code: '''// EventChannel
let eventChannel = FlutterEventChannel(
  name: "demo.counter.events",
  binaryMessenger: messenger
)
eventChannel.setStreamHandler(self)

// 實作 FlutterStreamHandler
extension AppDelegate: FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, 
                eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    methodEventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    methodEventSink = nil
    return nil
  }
}

// 發送事件
private func emitMethodEvents(count: Int) {
  guard count > 0 else { return }
  let ts = nowMs()
  let payload = makeCounterPayload(value: methodCounterValue, updatedAt: ts)
  for _ in 0..<count {
    methodEventSink?(payload)
  }
}''',
                language: 'swift',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'Android - Pigeon HostApi 實作',
            children: [
              const Text(
                'Pigeon 生成的 HostApi 實作：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              PageCodeBlock(
                code: '''class MainActivity : FlutterActivity(), CounterHostApi {
  private var pigeonCounterValue: Long = 0
  private var pigeonCounterUpdatedAt: Long = 0

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    val messenger = flutterEngine.dartExecutor.binaryMessenger
    
    // Pigeon HostApi
    CounterHostApi.setUp(messenger, this)
  }

  // CounterHostApi impl (Pigeon)
  override fun getCounter(): Counter = 
      Counter(pigeonCounterValue, pigeonCounterUpdatedAt)

  override fun increment(delta: Long): Counter {
    pigeonCounterValue += delta
    pigeonCounterUpdatedAt = nowMs()
    return Counter(pigeonCounterValue, pigeonCounterUpdatedAt)
  }

  override fun reset() {
    pigeonCounterValue = 0
    pigeonCounterUpdatedAt = nowMs()
  }
}''',
                language: 'kotlin',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'iOS/macOS - Pigeon HostApi 實作',
            children: [
              PageCodeBlock(
                code: '''extension AppDelegate: CounterHostApi {
  func getCounter() throws -> Counter {
    return Counter(
      value: pigeonCounterValue, 
      updatedAt: pigeonCounterUpdatedAt
    )
  }

  func increment(delta: Int64) throws -> Counter {
    pigeonCounterValue += delta
    pigeonCounterUpdatedAt = nowMs()
    let counter = Counter(
      value: pigeonCounterValue, 
      updatedAt: pigeonCounterUpdatedAt
    )
    return counter
  }

  func reset() throws {
    pigeonCounterValue = 0
    pigeonCounterUpdatedAt = nowMs()
  }
}''',
                language: 'swift',
                fontSize: 14.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// CounterChannels 實作說明頁面
class CounterChannelsImplementationPage extends StatelessWidget {
  const CounterChannelsImplementationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CounterChannels 實作')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '類別結構',
            children: [
              const Text(
                'CounterChannels 封裝了所有通訊方式，提供統一的介面：',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              PageCodeBlock(
                code: '''class CounterChannels {
  CounterChannels({
    MethodChannel? methodChannel,
    MethodChannel? methodChannelLongKeys,
    BasicMessageChannel<dynamic>? basicMessageChannel,
    EventChannel? eventChannel,
    CounterHostApi? pigeonApi,
  })  : _methodChannel = methodChannel ?? 
          const MethodChannel('demo.counter.method'),
        _methodChannelLong = methodChannelLongKeys ?? 
          const MethodChannel('demo.counter.method.long'),
        _basicMessageChannel = basicMessageChannel ??
          const BasicMessageChannel<dynamic>(
            'demo.counter.basic', 
            StandardMessageCodec()
          ),
        _eventChannel = eventChannel ?? 
          const EventChannel('demo.counter.events'),
        _pigeonApi = pigeonApi ?? CounterHostApi();

  final MethodChannel _methodChannel;
  final MethodChannel _methodChannelLong;
  final BasicMessageChannel<dynamic> _basicMessageChannel;
  final EventChannel _eventChannel;
  final CounterHostApi _pigeonApi;
}''',
                language: 'dart',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'MethodChannel 方法',
            children: [
              PageCodeBlock(
                code: '''// MethodChannel-based
Future<Counter> mcGetCounter() async => 
    _decodeCounter(await _methodChannel.invokeMethod('getCounter'));

Future<Counter> mcIncrement(int delta) async =>
    _decodeCounter(
      await _methodChannel.invokeMethod('increment', {'delta': delta})
    );

Future<Counter> mcReset() async => 
    _decodeCounter(await _methodChannel.invokeMethod('reset'));''',
                language: 'dart',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: 'Pigeon 方法',
            children: [
              PageCodeBlock(
                code: '''// Pigeon-based
Future<Counter> pigeonGetCounter() => _pigeonApi.getCounter();

Future<Counter> pigeonIncrement(int delta) => 
    _pigeonApi.increment(delta);

Future<void> pigeonReset() => _pigeonApi.reset();''',
                language: 'dart',
                fontSize: 14.0,
              ),
            ],
          ),
          const Divider(height: 32),
          _Section(
            title: '事件相關',
            children: [
              PageCodeBlock(
                code: '''// Events
Stream<Counter> events() => 
    _eventChannel.receiveBroadcastStream().map(_decodeCounter);

// Pigeon EventChannelApi
Stream<Counter> pigeonEvents({String instanceName = ''}) => 
    watch(instanceName: instanceName);

// FlutterApi from host -> flutter
void setupFlutterApi(CounterFlutterApi api) {
  CounterFlutterApi.setUp(api);
}

// Native -> Flutter burst emit (for perf test)
Future<void> mcEmitEvents(int count) => 
    _methodChannel.invokeMethod('emitMethodEvents', {'count': count});

// Pigeon EventChannelApi burst
Future<void> pigeonEmitWatchEvents(int count) =>
    const MethodChannel('demo.counter.pigeon.test')
        .invokeMethod('emitPigeonWatchEvents', {'count': count});

// Pigeon FlutterApi burst
Future<void> pigeonEmitFlutterEvents(int count) =>
    const MethodChannel('demo.counter.pigeon.test')
        .invokeMethod('emitPigeonFlutterEvents', {'count': count});''',
                language: 'dart',
                fontSize: 14.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper widgets
const _warmup = 10;

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.items,
  });

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.name,
    required this.code,
  });

  final String name;
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
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            PageCodeBlock(
              code: code,
              language: 'dart',
              fontSize: 14.0,
            ),
          ],
        ),
      ),
    );
  }
}

