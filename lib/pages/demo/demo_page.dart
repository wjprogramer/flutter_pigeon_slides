import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/counter_channels.dart';
import 'package:flutter_pigeon_slides/counter_ffi.dart';
import 'package:flutter_pigeon_slides/pigeons/counter.g.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final _channels = CounterChannels();
  final _ffi = CounterFfi();
  StreamSubscription<Counter>? _eventSub;

  Counter? _methodChannelCounter;
  Counter? _pigeon;
  Counter? _ffiCounter;
  List<int> _eventLatencies = [];
  bool _running = false;
  String _perfLog = '';

  @override
  void initState() {
    super.initState();
    _eventSub = _channels.events().listen((event) {
      setState(() {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (event.updatedAt != null) {
          _eventLatencies.add((now - event.updatedAt!).clamp(0, 1 << 31));
        }
      });
    });
    _refreshAll();
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    final method = await _channels.mcGetCounter();
    final pigeon = await _channels.pigeonGetCounter();
    final ffi = _ffi.getCounter();
    if (!mounted) return;
    setState(() {
      _methodChannelCounter = method;
      _pigeon = pigeon;
      _ffiCounter = ffi;
    });
  }

  Future<void> _incMc() async {
    final res = await _channels.mcIncrement(1);
    setState(() => _methodChannelCounter = res);
  }

  Future<void> _incPigeon() async {
    final res = await _channels.pigeonIncrement(1);
    setState(() => _pigeon = res);
  }

  Future<void> _incFfi() async {
    final res = _ffi.increment(1);
    setState(() => _ffiCounter = res);
  }

  Future<void> _resetAll() async {
    await _channels.mcReset();
    await _channels.pigeonReset();
    final ffi = _ffi.reset();
    setState(() {
      _methodChannelCounter = null;
      _pigeon = null;
      _ffiCounter = ffi;
      _eventLatencies = [];
    });
    await _refreshAll();
  }

  Future<void> _echoBasic() async {
    final res = await _channels.basicEcho({'op': 'echo', 'value': _methodChannelCounter?.value ?? 0});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Echo: $res')));
  }

  Future<void> _runPerf(String label, Future<void> Function() runner) async {
    if (_running) return;
    setState(() {
      _running = true;
      _perfLog = 'Running $label...';
    });
    final sw = Stopwatch()..start();
    await runner();
    sw.stop();
    final totalMs = sw.elapsedMilliseconds;
    setState(() {
      _running = false;
      _perfLog = '$label done: ${totalMs}ms';
    });
  }

  Future<void> _perfBatch(String label, Future<void> Function() op, {int times = 2000}) async {
    final durations = <int>[];
    for (var i = 0; i < times; i++) {
      final sw = Stopwatch()..start();
      await op();
      sw.stop();
      durations.add(sw.elapsedMicroseconds);
    }
    durations.sort();
    double avg = durations.reduce((a, b) => a + b) / durations.length;
    int p50 = durations[(durations.length * 0.5).floor()];
    int p95 = durations[(durations.length * 0.95).floor()];
    setState(() {
      _perfLog =
          '$label: n=$times avg=${avg.toStringAsFixed(1)}µs p50=$p50µs p95=$p95µs total=${durations.reduce((a,b)=>a+b)/1000.0}ms';
    });
  }

  Widget _section(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...children
        ]),
      ),
    );
  }

  Widget _counterRow(String label, Counter? c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(c == null ? '-' : 'value=${c.value} src=${c.source ?? ''}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Demo & Perf')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('Current', [
              _counterRow('MethodChannel', _methodChannelCounter),
              _counterRow('Pigeon', _pigeon),
              _counterRow('FFI', _ffiCounter),
              Text('Events received: ${_eventLatencies.length}'),
            ]),
            _section('Actions', [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(onPressed: _running ? null : _refreshAll, child: const Text('Refresh All')),
                  ElevatedButton(onPressed: _running ? null : _incMc, child: const Text('MethodChannel +1')),
                  ElevatedButton(onPressed: _running ? null : _incPigeon, child: const Text('Pigeon +1')),
                  ElevatedButton(onPressed: _running ? null : _incFfi, child: const Text('FFI +1')),
                  ElevatedButton(onPressed: _running ? null : _resetAll, child: const Text('Reset')),
                  ElevatedButton(onPressed: _running ? null : _echoBasic, child: const Text('Basic Echo')),
                ],
              ),
            ]),
            _section('Perf (端到端 T1~T4)', [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: _running
                        ? null
                        : () => _runPerf(
                              'MethodChannel x2000',
                              () => _perfBatch('MethodChannel', () => _channels.mcIncrement(1)),
                            ),
                    child: const Text('MethodChannel x2000'),
                  ),
                  ElevatedButton(
                    onPressed: _running
                        ? null
                        : () => _runPerf('Pigeon x2000', () => _perfBatch('Pigeon', () => _channels.pigeonIncrement(1))),
                    child: const Text('Pigeon x2000'),
                  ),
                  ElevatedButton(
                    onPressed: _running
                        ? null
                        : () => _runPerf('FFI x2000', () => _perfBatch('FFI', () async => _ffi.increment(1))),
                    child: const Text('FFI x2000'),
                  ),
                  ElevatedButton(
                    onPressed: _running
                        ? null
                        : () => _runPerf(
                              'BasicMessage x2000', () => _perfBatch('Basic', () => _channels.basicEcho({'v': 1}))),
                    child: const Text('BasicMessage x2000'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(_perfLog),
            ]),
          ],
        ),
      ),
    );
  }
}

