import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/counter_channels.dart';
import 'package:flutter_pigeon_slides/counter_ffi.dart';

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

  bool _running = false;
  String _status = '待執行';

  final List<double> _mcSeries = [];
  final List<double> _pigeonSeries = [];
  final List<double> _basicSeries = [];
  final List<double> _ffiSeries = [];

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

  Future<void> _runAuto() async {
    if (_running) return;
    setState(() {
      _running = true;
      _status = '準備中...';
      _mcSeries.clear();
      _pigeonSeries.clear();
      _basicSeries.clear();
      _ffiSeries.clear();
    });

    await _resetCounters();
    setState(() => _status = '執行中：$_batches 組，每組 $_batchSize 次');

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
    final maxY = allValues.isEmpty ? 0.0 : allValues.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 280,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX == 0 ? 1 : maxX - 1,
          minY: 0,
          maxY: maxY == 0 ? 1 : maxY * 1.1,
          lineTouchData: const LineTouchData(enabled: false),
          gridData: FlGridData(show: true, horizontalInterval: (maxY / 5).clamp(0.1, double.infinity)),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            if (_mcSeries.isNotEmpty)
              LineChartBarData(
                spots: _spots(_mcSeries),
                color: Colors.blue,
                barWidth: 2,
                isCurved: false,
                dotData: const FlDotData(show: false),
              ),
            if (_pigeonSeries.isNotEmpty)
              LineChartBarData(
                spots: _spots(_pigeonSeries),
                color: Colors.green,
                barWidth: 2,
                isCurved: false,
                dotData: const FlDotData(show: false),
              ),
            if (_basicSeries.isNotEmpty)
              LineChartBarData(
                spots: _spots(_basicSeries),
                color: Colors.orange,
                barWidth: 2,
                isCurved: false,
                dotData: const FlDotData(show: false),
              ),
            if (_ffiSeries.isNotEmpty)
              LineChartBarData(
                spots: _spots(_ffiSeries),
                color: Colors.purple,
                barWidth: 2,
                isCurved: false,
                dotData: const FlDotData(show: false),
              ),
          ],
        ),
      ),
    );
  }

  Widget _legend() {
    Widget chip(Color c, String t) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: c),
            const SizedBox(width: 6),
            Text(t),
          ],
        );
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        chip(Colors.blue, 'MethodChannel'),
        chip(Colors.green, 'Pigeon HostApi'),
        chip(Colors.orange, 'BasicMessageChannel'),
        chip(Colors.purple, 'FFI'),
      ],
    );
  }

  Widget _summaryRow(String label, List<double> data) {
    final last = data.isNotEmpty ? data.last.toStringAsFixed(1) : '-';
    final avg =
        data.isNotEmpty ? (data.reduce((a, b) => a + b) / data.length).toStringAsFixed(1) : '-';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text('最新: $last µs | 平均: $avg µs'),
      ],
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
            _legend(),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _chart(),
                    const SizedBox(height: 12),
                    _summaryRow('MethodChannel', _mcSeries),
                    _summaryRow('Pigeon HostApi', _pigeonSeries),
                    _summaryRow('BasicMessageChannel', _basicSeries),
                    _summaryRow('FFI', _ffiSeries),
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

