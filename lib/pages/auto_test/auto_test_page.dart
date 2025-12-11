import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/counter_channels.dart';
import 'package:flutter_pigeon_slides/counter_ffi.dart';
import 'package:flutter_pigeon_slides/pigeons/counter.g.dart';

class AutoTestPage extends StatefulWidget {
  const AutoTestPage({super.key});

  @override
  State<AutoTestPage> createState() => _AutoTestPageState();
}

class _AutoTestPageState extends State<AutoTestPage> {
  final _channels = CounterChannels();
  final _ffi = CounterFfi();

  final int _batchSize = 2000;
  final int _batches = 30;
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
  final List<double> _m2fMethodSeries = [];
  final List<double> _m2fPigeonEventSeries = [];
  final List<double> _m2fPigeonFlutterSeries = [];
  bool _mcEnabled = true;
  bool _pigeonEnabled = true;
  bool _basicEnabled = true;
  bool _ffiEnabled = true;
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

  Future<void> _resetCounters() async {
    await _channels.mcReset();
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

  List<FlSpot> _spots(List<double> data) =>
      data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

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
  }) {
    final displayColor = color.withValues(alpha: enabled ? 1 : 0.2);
    final last = data.isNotEmpty ? data.last.toStringAsFixed(1) : '-';
    final avg = data.isNotEmpty
        ? (data.reduce((a, b) => a + b) / data.length).toStringAsFixed(1)
        : '-';
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(width: 12, height: 12, color: displayColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
              ),
            ),
            Text(
              '最新: $last µs | 平均: $avg µs',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _methodEventSub = _channels.events().listen((event) {
      if (!_collectMethodEvents || _methodBurst.length >= _expectEvents) return;
      if (event.updatedAt != null) {
        final now = DateTime.now().millisecondsSinceEpoch.toDouble();
        _methodBurst.add((now - event.updatedAt!.toDouble()).clamp(0, double.maxFinite));
        if (_methodBurst.length >= _expectEvents) {
          _eventCompleter?.complete();
        }
      }
    });
    _pigeonEventSub = _channels.pigeonEvents().listen((event) {
      if (!_collectPigeonEvents || _pigeonBurst.length >= _expectEvents) return;
      if (event.updatedAt != null) {
        final now = DateTime.now().millisecondsSinceEpoch.toDouble();
        _pigeonBurst.add((now - event.updatedAt!.toDouble()).clamp(0, double.maxFinite));
        if (_pigeonBurst.length >= _expectEvents) {
          _eventCompleter?.complete();
        }
      }
    });
    _channels.setupFlutterApi(_DemoFlutterApi(onCounterHandler: (counter) {
      if (_collectPigeonFlutter && _pigeonFlutterBurst.length < _expectEvents) {
        final now = DateTime.now().millisecondsSinceEpoch.toDouble();
        final ts = (counter.updatedAt?.toDouble() ?? now);
        _pigeonFlutterBurst.add((now - ts).clamp(0, double.maxFinite));
        if (_pigeonFlutterBurst.length >= _expectEvents) {
          _eventCompleter?.complete();
        }
      }
    }));
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
      _m2fMethodSeries.clear();
      _m2fPigeonEventSeries.clear();
      _m2fPigeonFlutterSeries.clear();
      _methodBurst.clear();
      _pigeonBurst.clear();
      _pigeonFlutterBurst.clear();
    });

    await _resetCounters();
    setState(() => _status = '執行中：Flutter → 原生 $_batches 組，每組 $_batchSize 次');

    for (var i = 0; i < _batches && _running; i++) {
      final mc = await _measureAvgMicros(() => _channels.mcIncrement(1));
      final pigeon = await _measureAvgMicros(() => _channels.pigeonIncrement(1));
      final basic = await _measureAvgMicros(() => _channels.basicEcho({'v': 1}));
      final ffiVal = await _measureAvgMicros(() async {
        _ffi.increment(1);
      });

      if (!_running) break;
      setState(() {
        _mcSeries.add(mc);
        _pigeonSeries.add(pigeon);
        _basicSeries.add(basic);
        _ffiSeries.add(ffiVal);
        _status = '進度 ${i + 1}/$_batches';
      });

      await Future.delayed(const Duration(milliseconds: 1));
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
    final avg =
        _methodBurst.isEmpty ? 0.0 : (_methodBurst.reduce((a, b) => a + b) / _methodBurst.length);
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
    await _channels.pigeonEmitEvents(_eventBurst);
    await _waitOrTimeout(_eventCompleter!);
    _collectPigeonEvents = false;
    final avg =
        _pigeonBurst.isEmpty ? 0.0 : (_pigeonBurst.reduce((a, b) => a + b) / _pigeonBurst.length);
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
    await _channels.pigeonEmitEvents(_eventBurst);
    await _waitOrTimeout(_eventCompleter!);
    _collectPigeonFlutter = false;
    final avg = _pigeonFlutterBurst.isEmpty
        ? 0.0
        : (_pigeonFlutterBurst.reduce((a, b) => a + b) / _pigeonFlutterBurst.length);
    _pigeonFlutterBurst.clear();
    _eventCompleter = null;
    return avg;
  }

  Future<void> _runNativeToFlutter() async {
    setState(() {
      _status = '準備中...（原生 → Flutter）';
    });
    _m2fMethodSeries.clear();
    _m2fPigeonEventSeries.clear();
    _m2fPigeonFlutterSeries.clear();
    for (var i = 0; i < _eventBatches && _running; i++) {
      setState(() => _status = '原生 → Flutter 進度 ${i + 1}/$_eventBatches');
      final m = await _measureMethodToFlutter();
      final pe = await _measurePigeonEventToFlutter();
      final pf = await _measurePigeonFlutterApiToFlutter();
      if (!_running) break;
      setState(() {
        _m2fMethodSeries.add(m);
        _m2fPigeonEventSeries.add(pe);
        _m2fPigeonFlutterSeries.add(pf);
      });
    }
  }

  Widget _chart() {
    if (_mcSeries.isEmpty &&
        _pigeonSeries.isEmpty &&
        _basicSeries.isEmpty &&
        _ffiSeries.isEmpty) {
      return const Text('尚無資料，請先執行自動測試');
    }

    final maxX = [
      _mcSeries.length,
      _pigeonSeries.length,
      _basicSeries.length,
      _ffiSeries.length
    ].reduce((a, b) => a > b ? a : b).toDouble();

    final allValues = [
      ..._mcSeries,
      ..._pigeonSeries,
      ..._basicSeries,
      ..._ffiSeries
    ];
    final rawMaxY = allValues.isEmpty ? 0.0 : allValues.reduce((a, b) => a > b ? a : b);
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
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('批次編號 (0-based)'),
              axisNameSize: 22,
              sideTitles: const SideTitles(showTitles: true, reservedSize: 22, interval: 5),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text('平均耗時 (µs)'),
              axisNameSize: 22,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 20,
              ),
            ),
          ),
          lineBarsData: [
            if (_mcSeries.isNotEmpty)
              _bar(_mcSeries, Colors.blue, _mcEnabled),
            if (_pigeonSeries.isNotEmpty)
              _bar(_pigeonSeries, Colors.green, _pigeonEnabled),
            if (_basicSeries.isNotEmpty)
              _bar(_basicSeries, Colors.orange, _basicEnabled),
            if (_ffiSeries.isNotEmpty)
              _bar(_ffiSeries, Colors.purple, _ffiEnabled),
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
      _m2fPigeonFlutterSeries.length
    ].reduce((a, b) => a > b ? a : b).toDouble();

    final allValues = [
      ..._m2fMethodSeries,
      ..._m2fPigeonEventSeries,
      ..._m2fPigeonFlutterSeries
    ];
    final rawMaxY = allValues.isEmpty ? 0.0 : allValues.reduce((a, b) => a > b ? a : b);
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
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('批次編號 (0-based)'),
              axisNameSize: 22,
              sideTitles: const SideTitles(showTitles: true, reservedSize: 22, interval: 2),
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
              _bar(_m2fPigeonFlutterSeries, Colors.teal, _m2fPigeonFlutterEnabled),
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
                    const SizedBox(height: 8),
                    _chart(),
                    const SizedBox(height: 8),
                    _seriesRow(
                      label: 'MethodChannel',
                      color: Colors.blue,
                      data: _mcSeries,
                      enabled: _mcEnabled,
                      onToggle: () => setState(() => _mcEnabled = !_mcEnabled),
                    ),
                    _seriesRow(
                      label: 'Pigeon HostApi',
                      color: Colors.green,
                      data: _pigeonSeries,
                      enabled: _pigeonEnabled,
                      onToggle: () => setState(() => _pigeonEnabled = !_pigeonEnabled),
                    ),
                    _seriesRow(
                      label: 'BasicMessageChannel',
                      color: Colors.orange,
                      data: _basicSeries,
                      enabled: _basicEnabled,
                      onToggle: () => setState(() => _basicEnabled = !_basicEnabled),
                    ),
                    _seriesRow(
                      label: 'FFI',
                      color: Colors.purple,
                      data: _ffiSeries,
                      enabled: _ffiEnabled,
                      onToggle: () => setState(() => _ffiEnabled = !_ffiEnabled),
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
                      onToggle: () => setState(() => _m2fMethodEnabled = !_m2fMethodEnabled),
                    ),
                    _seriesRow(
                      label: 'Pigeon EventChannelApi',
                      color: Colors.green,
                      data: _m2fPigeonEventSeries,
                      enabled: _m2fPigeonEventEnabled,
                      onToggle: () =>
                          setState(() => _m2fPigeonEventEnabled = !_m2fPigeonEventEnabled),
                    ),
                    _seriesRow(
                      label: 'Pigeon FlutterApi',
                      color: Colors.teal,
                      data: _m2fPigeonFlutterSeries,
                      enabled: _m2fPigeonFlutterEnabled,
                      onToggle: () =>
                          setState(() => _m2fPigeonFlutterEnabled = !_m2fPigeonFlutterEnabled),
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

