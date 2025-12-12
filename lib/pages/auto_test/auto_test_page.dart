import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/auto_test_results.dart';
import 'package:flutter_pigeon_slides/counter_channels.dart';
import 'package:flutter_pigeon_slides/counter_ffi.dart';
import 'package:flutter_pigeon_slides/pigeons/counter.g.dart';

const _warmup = 10;

class AutoTestPage extends StatefulWidget {
  const AutoTestPage({super.key});

  @override
  State<AutoTestPage> createState() => _AutoTestPageState();
}

class _AutoTestPageState extends State<AutoTestPage> {
  final _channels = CounterChannels();
  final _ffi = CounterFfi();

  final int _batchSize = 2000;
  final int _batches = 60;
  final int _eventBurst = 2000;
  final int _eventBatches = 30;

  bool _running = false;
  String _status = '待執行';

  StreamSubscription<Counter>? _methodEventSub;
  StreamSubscription<Counter>? _pigeonEventSub;

  final List<double> _mcSeries = [];
  final List<double> _pigeonSeries = [];
  final List<double> _basicSeries = [];
  final List<double> _ffiSeries = [];

  /// Jacky 推薦加入此測試作為對照組
  final List<double> _dartSeries = [];
  final List<double> _mcLongSeries = [];
  double _mcTotalMs = 0;
  double _pigeonTotalMs = 0;
  double _basicTotalMs = 0;
  double _ffiTotalMs = 0;
  double _dartTotalMs = 0;
  double _mcLongTotalMs = 0;
  final List<double> _m2fMethodSeries = [];
  final List<double> _m2fPigeonEventSeries = [];
  final List<double> _m2fPigeonFlutterSeries = [];
  bool _mcEnabled = true;
  bool _pigeonEnabled = true;
  bool _basicEnabled = true;
  bool _ffiEnabled = true;
  bool _dartEnabled = true;
  bool _mcLongEnabled = true;
  bool _m2fMethodEnabled = true;
  bool _m2fPigeonEventEnabled = true;
  bool _m2fPigeonFlutterEnabled = true;

  bool _collectMethodEvents = false;
  bool _collectPigeonEvents = false;
  bool _collectPigeonFlutter = false;
  int _expectEvents = 0;
  final List<double> _methodBurst = [];
  final List<double> _pigeonBurst = [];
  final List<double> _pigeonFlutterBurst = [];
  Completer<void>? _eventCompleter;

  double _scale(BuildContext context, double base) =>
      MediaQuery.of(context).textScaler.scale(base);

  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  Future<void> _resetCounters() async {
    await _channels.mcReset();
    await _channels.mcLongReset();
    await _channels.pigeonReset();
    _ffi.reset();
  }

  Future<double> _measureAvgMicros(Future<void> Function() op) async {
    final sw = Stopwatch()..start();
    for (var i = 0; i < _batchSize; i++) {
      await op();
    }
    sw.stop();
    return sw.elapsedMicroseconds / _batchSize;
  }

  List<FlSpot> _spots(List<double> data) => data
      .asMap()
      .entries
      .map((e) => FlSpot(e.key.toDouble(), e.value))
      .toList();

  double _roundUp(double value, {double step = 20}) {
    if (value <= 0) return step;
    return (value / step).ceil() * step;
  }

  LineChartBarData _bar(List<double> data, Color color, bool enabled) {
    return LineChartBarData(
      spots: _spots(data),
      color: color.withValues(alpha: enabled ? 1 : 0.2),
      barWidth: 2,
      isCurved: false,
      dotData: const FlDotData(show: false),
    );
  }

  Widget _seriesRow({
    required String label,
    required Color color,
    required List<double> data,
    required bool enabled,
    required VoidCallback onToggle,
    required String unit,
    double? totalMs,
  }) {
    final displayColor = color.withValues(alpha: enabled ? 1 : 0.2);
    final last = data.isNotEmpty ? data.last.toStringAsFixed(1) : '-';
    final avg = data.isNotEmpty
        ? (data.reduce((a, b) => a + b) / data.length).toStringAsFixed(1)
        : '-';
    final totalText = totalMs != null
        ? ' | 總計: ${totalMs.toStringAsFixed(1)} ms'
        : '';
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(width: 12, height: 12, color: displayColor),
            const SizedBox(width: 8),
            Expanded(child: Text(label)),
            Text('最新: $last $unit | 平均: $avg $unit$totalText'),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    
    // 從全局結果加載之前的測試數據
    final results = AutoTestResults();
    _mcSeries.clear();
    _mcSeries.addAll(results.mcSeries);
    _mcLongSeries.clear();
    _mcLongSeries.addAll(results.mcLongSeries);
    _pigeonSeries.clear();
    _pigeonSeries.addAll(results.pigeonSeries);
    _basicSeries.clear();
    _basicSeries.addAll(results.basicSeries);
    _ffiSeries.clear();
    _ffiSeries.addAll(results.ffiSeries);
    _dartSeries.clear();
    _dartSeries.addAll(results.dartSeries);
    _mcTotalMs = results.mcTotalMs;
    _mcLongTotalMs = results.mcLongTotalMs;
    _pigeonTotalMs = results.pigeonTotalMs;
    _basicTotalMs = results.basicTotalMs;
    _ffiTotalMs = results.ffiTotalMs;
    _dartTotalMs = results.dartTotalMs;
    _m2fMethodSeries.clear();
    _m2fMethodSeries.addAll(results.m2fMethodSeries);
    _m2fPigeonEventSeries.clear();
    _m2fPigeonEventSeries.addAll(results.m2fPigeonEventSeries);
    _m2fPigeonFlutterSeries.clear();
    _m2fPigeonFlutterSeries.addAll(results.m2fPigeonFlutterSeries);
    
    _methodEventSub = _channels.events().listen((event) {
      if (!_collectMethodEvents || _methodBurst.length >= _expectEvents) return;
      if (event.updatedAt != null) {
        final now = DateTime.now().millisecondsSinceEpoch.toDouble();
        _methodBurst.add(
          (now - event.updatedAt!.toDouble()).clamp(0, double.maxFinite),
        );
        if (_methodBurst.length >= _expectEvents) {
          _eventCompleter?.complete();
        }
      }
    });
    _pigeonEventSub = _channels.pigeonEvents().listen((event) {
      if (!_collectPigeonEvents || _pigeonBurst.length >= _expectEvents) return;
      if (event.updatedAt != null) {
        final now = DateTime.now().millisecondsSinceEpoch.toDouble();
        _pigeonBurst.add(
          (now - event.updatedAt!.toDouble()).clamp(0, double.maxFinite),
        );
        if (_pigeonBurst.length >= _expectEvents) {
          _eventCompleter?.complete();
        }
      }
    });
    _channels.setupFlutterApi(
      _DemoFlutterApi(
        onCounterHandler: (counter) {
          if (_collectPigeonFlutter &&
              _pigeonFlutterBurst.length < _expectEvents) {
            final now = DateTime.now().millisecondsSinceEpoch.toDouble();
            final ts = (counter.updatedAt?.toDouble() ?? now);
            _pigeonFlutterBurst.add((now - ts).clamp(0, double.maxFinite));
            if (_pigeonFlutterBurst.length >= _expectEvents) {
              _eventCompleter?.complete();
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _methodEventSub?.cancel();
    _pigeonEventSub?.cancel();
    super.dispose();
  }

  Future<void> _runAuto() async {
    if (_running) return;
    setState(() {
      _running = true;
      _status = '準備中...（Flutter → 原生）';
      _mcSeries.clear();
      _pigeonSeries.clear();
      _basicSeries.clear();
      _ffiSeries.clear();
      _dartSeries.clear();
      _mcLongSeries.clear();
      _mcTotalMs = 0;
      _pigeonTotalMs = 0;
      _basicTotalMs = 0;
      _ffiTotalMs = 0;
      _dartTotalMs = 0;
      _mcLongTotalMs = 0;
      _m2fMethodSeries.clear();
      _m2fPigeonEventSeries.clear();
      _m2fPigeonFlutterSeries.clear();
      _methodBurst.clear();
      _pigeonBurst.clear();
      _pigeonFlutterBurst.clear();
    });
    
    // 清除全局結果（新測試開始時）
    AutoTestResults().clear();
    
    // 等待 UI 更新完成，避免影響實驗
    await Future.delayed(const Duration(milliseconds: 100));

    await _resetCounters();
    setState(() => _status = '執行中：Flutter → 原生，每個方法 $_batches 組，每組 $_batchSize 次');
    
    // 等待 UI 更新完成，避免影響實驗
    await Future.delayed(const Duration(milliseconds: 100));

    // ignore: unused_local_variable
    var dartCounter = 0;
    final ops = <(String, String, Future<double> Function())>[
      ('mc', 'MethodChannel', () => _measureAvgMicros(() => _channels.mcIncrement(1))),
      ('mcLong', 'MethodChannel (long keys)', () => _measureAvgMicros(() => _channels.mcLongIncrement(1))),
      ('pigeon', 'Pigeon HostApi', () => _measureAvgMicros(() => _channels.pigeonIncrement(1))),
      ('basic', 'BasicMessageChannel', () => _measureAvgMicros(() => _channels.basicEcho({'v': 1}))),
      ('ffi', 'FFI', () => _measureAvgMicros(() async => _ffi.increment(1))),
      (
        'dart',
        'Pure Dart (baseline)',
        () => _measureAvgMicros(() async {
          // Pure Dart baseline; minimal成本 (仍做少量運算避免被完全優化掉)
          dartCounter += 1;
        }),
      ),
    ];

    // 使用臨時變數收集結果，避免執行過程中的 setState 影響性能測試
    final tempMcSeries = <double>[];
    final tempMcLongSeries = <double>[];
    final tempPigeonSeries = <double>[];
    final tempBasicSeries = <double>[];
    final tempFfiSeries = <double>[];
    final tempDartSeries = <double>[];
    double tempMcTotalMs = 0;
    double tempMcLongTotalMs = 0;
    double tempPigeonTotalMs = 0;
    double tempBasicTotalMs = 0;
    double tempFfiTotalMs = 0;
    double tempDartTotalMs = 0;

    // 每個方法連續執行完整的批次，避免執行順序影響結果
    for (final op in ops) {
      if (!_running) break;
      
      final opKey = op.$1;
      final opFunc = op.$3;
      
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
              tempMcTotalMs += result * _batchSize / 1000.0;
              break;
            case 'mcLong':
              tempMcLongSeries.add(result);
              tempMcLongTotalMs += result * _batchSize / 1000.0;
              break;
            case 'pigeon':
              tempPigeonSeries.add(result);
              tempPigeonTotalMs += result * _batchSize / 1000.0;
              break;
            case 'basic':
              tempBasicSeries.add(result);
              tempBasicTotalMs += result * _batchSize / 1000.0;
              break;
            case 'ffi':
              tempFfiSeries.add(result);
              tempFfiTotalMs += result * _batchSize / 1000.0;
              break;
            case 'dart':
              tempDartSeries.add(result);
              tempDartTotalMs += result * _batchSize / 1000.0;
              break;
          }
        }

        await Future.delayed(const Duration(milliseconds: 1));
      }
    }

    // 執行完成後，一次性更新 UI（避免執行過程中的 setState 影響性能測試）
    if (mounted && _running) {
      setState(() {
        _mcSeries.addAll(tempMcSeries);
        _mcLongSeries.addAll(tempMcLongSeries);
        _pigeonSeries.addAll(tempPigeonSeries);
        _basicSeries.addAll(tempBasicSeries);
        _ffiSeries.addAll(tempFfiSeries);
        _dartSeries.addAll(tempDartSeries);
        _mcTotalMs += tempMcTotalMs;
        _mcLongTotalMs += tempMcLongTotalMs;
        _pigeonTotalMs += tempPigeonTotalMs;
        _basicTotalMs += tempBasicTotalMs;
        _ffiTotalMs += tempFfiTotalMs;
        _dartTotalMs += tempDartTotalMs;
      });
      
      // 保存結果到全局，避免離開頁面後結果消失
      AutoTestResults().updateFlutterToNative(
        mc: _mcSeries,
        mcLong: _mcLongSeries,
        pigeon: _pigeonSeries,
        basic: _basicSeries,
        ffi: _ffiSeries,
        dart: _dartSeries,
        mcTotal: _mcTotalMs,
        mcLongTotal: _mcLongTotalMs,
        pigeonTotal: _pigeonTotalMs,
        basicTotal: _basicTotalMs,
        ffiTotal: _ffiTotalMs,
        dartTotal: _dartTotalMs,
      );
    }

    if (_running) {
      await _runNativeToFlutter();
    }

    if (mounted) {
      setState(() {
        _running = false;
        _status = '完成';
      });
    }
  }

  void _stop() {
    setState(() {
      _running = false;
      _status = '已停止';
    });
  }

  Future<void> _waitOrTimeout(Completer<void> c) async {
    try {
      await c.future.timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  Future<double> _measureMethodToFlutter() async {
    _collectMethodEvents = true;
    _collectPigeonEvents = false;
    _collectPigeonFlutter = false;
    _expectEvents = _eventBurst;
    _methodBurst.clear();
    _eventCompleter = Completer<void>();
    await _channels.mcEmitEvents(_eventBurst);
    await _waitOrTimeout(_eventCompleter!);
    _collectMethodEvents = false;
    final avg = _methodBurst.isEmpty
        ? 0.0
        : (_methodBurst.reduce((a, b) => a + b) / _methodBurst.length);
    _methodBurst.clear();
    _eventCompleter = null;
    return avg;
  }

  Future<double> _measurePigeonEventToFlutter() async {
    _collectMethodEvents = false;
    _collectPigeonEvents = true;
    _collectPigeonFlutter = false;
    _expectEvents = _eventBurst;
    _pigeonBurst.clear();
    _eventCompleter = Completer<void>();
    await _channels.pigeonEmitWatchEvents(_eventBurst);
    await _waitOrTimeout(_eventCompleter!);
    _collectPigeonEvents = false;
    final avg = _pigeonBurst.isEmpty
        ? 0.0
        : (_pigeonBurst.reduce((a, b) => a + b) / _pigeonBurst.length);
    _pigeonBurst.clear();
    _eventCompleter = null;
    return avg;
  }

  Future<double> _measurePigeonFlutterApiToFlutter() async {
    _collectMethodEvents = false;
    _collectPigeonEvents = false;
    _collectPigeonFlutter = true;
    _expectEvents = _eventBurst;
    _pigeonFlutterBurst.clear();
    _eventCompleter = Completer<void>();
    await _channels.pigeonEmitFlutterEvents(_eventBurst);
    await _waitOrTimeout(_eventCompleter!);
    _collectPigeonFlutter = false;
    final avg = _pigeonFlutterBurst.isEmpty
        ? 0.0
        : (_pigeonFlutterBurst.reduce((a, b) => a + b) /
              _pigeonFlutterBurst.length);
    _pigeonFlutterBurst.clear();
    _eventCompleter = null;
    return avg;
  }

  Future<void> _runNativeToFlutter() async {
    if (!_running) return;
    
    // 使用臨時變數收集結果，避免執行過程中的 setState 影響性能測試
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
    
    // 執行完成後，一次性更新 UI（避免執行過程中的 setState 影響性能測試）
    if (mounted && _running) {
      setState(() {
        _m2fMethodSeries.addAll(tempM2fMethodSeries);
        _m2fPigeonEventSeries.addAll(tempM2fPigeonEventSeries);
        _m2fPigeonFlutterSeries.addAll(tempM2fPigeonFlutterSeries);
      });
      
      // 保存結果到全局，避免離開頁面後結果消失
      AutoTestResults().updateNativeToFlutter(
        method: _m2fMethodSeries,
        pigeonEvent: _m2fPigeonEventSeries,
        pigeonFlutter: _m2fPigeonFlutterSeries,
      );
    }
  }

  Widget _chart() {
    if (_mcSeries.isEmpty &&
        _mcLongSeries.isEmpty &&
        _pigeonSeries.isEmpty &&
        _basicSeries.isEmpty &&
        _ffiSeries.isEmpty &&
        _dartSeries.isEmpty) {
      return const Text('尚無資料，請先執行自動測試');
    }

    final maxX = [
      _mcSeries.length,
      _mcLongSeries.length,
      _pigeonSeries.length,
      _basicSeries.length,
      _ffiSeries.length,
      _dartSeries.length,
    ].reduce((a, b) => a > b ? a : b).toDouble();

    final allValues = [
      ..._mcSeries,
      ..._mcLongSeries,
      ..._pigeonSeries,
      ..._basicSeries,
      ..._ffiSeries,
      ..._dartSeries,
    ];
    final rawMaxY = allValues.isEmpty
        ? 0.0
        : allValues.reduce((a, b) => a > b ? a : b);
    final maxY = _roundUp(rawMaxY, step: 20);

    final chartHeight = _clamp(_scale(context, 280), 200, 520);
    final axisNameSize = _clamp(_scale(context, 22), 16, 44);
    final leftReserved = _clamp(_scale(context, 40), 28, 80);
    final bottomReserved = _clamp(_scale(context, 22), 16, 44);

    return SizedBox(
      height: chartHeight,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX == 0 ? 1 : maxX - 1,
          minY: 0,
          maxY: maxY,
          lineTouchData: const LineTouchData(enabled: false),
          gridData: FlGridData(show: true, horizontalInterval: 20),
          // TODO: 現在有點問題，但先不管
          // rangeAnnotations: RangeAnnotations(
          //   verticalRangeAnnotations: [
          //     VerticalRangeAnnotation(
          //       x1: -0.5,
          //       x2: 1.5,
          //       color: Colors.grey.withOpacity(0.12),
          //     ),
          //   ],
          // ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('批次編號 (0-based)'),
              axisNameSize: axisNameSize,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: bottomReserved,
                interval: 5,
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text('平均耗時 (µs)'),
              axisNameSize: axisNameSize,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: leftReserved,
                interval: 20,
              ),
            ),
          ),
          lineBarsData: [
            if (_mcSeries.isNotEmpty) _bar(_mcSeries, Colors.blue, _mcEnabled),
            if (_mcLongSeries.isNotEmpty)
              _bar(_mcLongSeries, Colors.indigo, _mcLongEnabled),
            if (_pigeonSeries.isNotEmpty)
              _bar(_pigeonSeries, Colors.green, _pigeonEnabled),
            if (_basicSeries.isNotEmpty)
              _bar(_basicSeries, Colors.orange, _basicEnabled),
            if (_ffiSeries.isNotEmpty)
              _bar(_ffiSeries, Colors.purple, _ffiEnabled),
            if (_dartSeries.isNotEmpty)
              _bar(_dartSeries, Colors.teal, _dartEnabled),
          ],
        ),
      ),
    );
  }

  Widget _chartNativeToFlutter() {
    if (_m2fMethodSeries.isEmpty &&
        _m2fPigeonEventSeries.isEmpty &&
        _m2fPigeonFlutterSeries.isEmpty) {
      return const Text('尚無資料，請先執行自動測試');
    }

    final maxX = [
      _m2fMethodSeries.length,
      _m2fPigeonEventSeries.length,
      _m2fPigeonFlutterSeries.length,
    ].reduce((a, b) => a > b ? a : b).toDouble();

    final allValues = [
      ..._m2fMethodSeries,
      ..._m2fPigeonEventSeries,
      ..._m2fPigeonFlutterSeries,
    ];
    final rawMaxY = allValues.isEmpty
        ? 0.0
        : allValues.reduce((a, b) => a > b ? a : b);
    final maxY = _roundUp(rawMaxY, step: 20);

    return SizedBox(
      height: 280,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX == 0 ? 1 : maxX - 1,
          minY: 0,
          maxY: maxY,
          lineTouchData: const LineTouchData(enabled: false),
          gridData: FlGridData(show: true, horizontalInterval: 20),
          // TODO: 現在有點問題，但先不管
          // rangeAnnotations: RangeAnnotations(
          //   verticalRangeAnnotations: [
          //     VerticalRangeAnnotation(
          //       x1: -0.5,
          //       x2: 1.5,
          //       color: Colors.grey.withOpacity(0.12),
          //     ),
          //   ],
          // ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('批次編號 (0-based)'),
              axisNameSize: 22,
              sideTitles: const SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 2,
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text('原生 → Flutter 平均耗時 (µs)'),
              axisNameSize: 22,
              sideTitles: const SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: 20,
              ),
            ),
          ),
          lineBarsData: [
            if (_m2fMethodSeries.isNotEmpty)
              _bar(_m2fMethodSeries, Colors.blue, _m2fMethodEnabled),
            if (_m2fPigeonEventSeries.isNotEmpty)
              _bar(_m2fPigeonEventSeries, Colors.green, _m2fPigeonEventEnabled),
            if (_m2fPigeonFlutterSeries.isNotEmpty)
              _bar(
                _m2fPigeonFlutterSeries,
                Colors.teal,
                _m2fPigeonFlutterEnabled,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('自動長跑測試 / 趨勢')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('狀態：$_status'),
            const SizedBox(height: 8),
            Text('批次大小：$_batchSize / 批次數量：$_batches'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _running ? null : _runAuto,
                  child: const Text('開始自動測試（會先重置）'),
                ),
                ElevatedButton(
                  onPressed: _running ? _stop : null,
                  child: const Text('停止'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Flutter → 原生'),
                    const SizedBox(height: 4),
                    const Text('註：前 $_warmup 批為 warm-up，不納入比較'),
                    const SizedBox(height: 8),
                    _chart(),
                    const SizedBox(height: 8),
                    _seriesRow(
                      label: 'MethodChannel',
                      color: Colors.blue,
                      data: _mcSeries,
                      enabled: _mcEnabled,
                      onToggle: () => setState(() => _mcEnabled = !_mcEnabled),
                      unit: 'µs',
                      totalMs: _mcTotalMs,
                    ),
                    _seriesRow(
                      label: 'MethodChannel (long keys)',
                      color: Colors.indigo,
                      data: _mcLongSeries,
                      enabled: _mcLongEnabled,
                      onToggle: () =>
                          setState(() => _mcLongEnabled = !_mcLongEnabled),
                      unit: 'µs',
                      totalMs: _mcLongTotalMs,
                    ),
                    _seriesRow(
                      label: 'Pigeon HostApi',
                      color: Colors.green,
                      data: _pigeonSeries,
                      enabled: _pigeonEnabled,
                      onToggle: () =>
                          setState(() => _pigeonEnabled = !_pigeonEnabled),
                      unit: 'µs',
                      totalMs: _pigeonTotalMs,
                    ),
                    _seriesRow(
                      label: 'BasicMessageChannel',
                      color: Colors.orange,
                      data: _basicSeries,
                      enabled: _basicEnabled,
                      onToggle: () =>
                          setState(() => _basicEnabled = !_basicEnabled),
                      unit: 'µs',
                      totalMs: _basicTotalMs,
                    ),
                    _seriesRow(
                      label: 'FFI',
                      color: Colors.purple,
                      data: _ffiSeries,
                      enabled: _ffiEnabled,
                      onToggle: () =>
                          setState(() => _ffiEnabled = !_ffiEnabled),
                      unit: 'µs',
                      totalMs: _ffiTotalMs,
                    ),
                    _seriesRow(
                      label: 'Pure Dart (baseline)',
                      color: Colors.teal,
                      data: _dartSeries,
                      enabled: _dartEnabled,
                      onToggle: () =>
                          setState(() => _dartEnabled = !_dartEnabled),
                      unit: 'µs',
                      totalMs: _dartTotalMs,
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('原生 → Flutter'),
                    const SizedBox(height: 12),
                    _chartNativeToFlutter(),
                    const SizedBox(height: 8),
                    _seriesRow(
                      label: 'EventChannel',
                      color: Colors.blue,
                      data: _m2fMethodSeries,
                      enabled: _m2fMethodEnabled,
                      onToggle: () => setState(
                        () => _m2fMethodEnabled = !_m2fMethodEnabled,
                      ),
                      unit: 'µs',
                    ),
                    _seriesRow(
                      label: 'Pigeon EventChannelApi',
                      color: Colors.green,
                      data: _m2fPigeonEventSeries,
                      enabled: _m2fPigeonEventEnabled,
                      onToggle: () => setState(
                        () => _m2fPigeonEventEnabled = !_m2fPigeonEventEnabled,
                      ),
                      unit: 'µs',
                    ),
                    _seriesRow(
                      label: 'Pigeon FlutterApi',
                      color: Colors.teal,
                      data: _m2fPigeonFlutterSeries,
                      enabled: _m2fPigeonFlutterEnabled,
                      onToggle: () => setState(
                        () => _m2fPigeonFlutterEnabled =
                            !_m2fPigeonFlutterEnabled,
                      ),
                      unit: 'µs',
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

class _DemoFlutterApi extends CounterFlutterApi {
  _DemoFlutterApi({required this.onCounterHandler});

  final void Function(Counter counter) onCounterHandler;

  @override
  void onCounter(Counter counter) => onCounterHandler(counter);
}
