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

  String _fmtCounter(Counter? c) {
    if (c == null) return '-';
    final src = c.source ?? '';
    return 'value=${c.value}${src.isEmpty ? '' : ' src=$src'}';
  }

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

  Future<void> _refreshMethodChannel() async {
    final method = await _channels.mcGetCounter();
    if (!mounted) return;
    setState(() => _methodChannelCounter = method);
  }

  Future<void> _refreshPigeon() async {
    final pigeon = await _channels.pigeonGetCounter();
    if (!mounted) return;
    setState(() => _pigeon = pigeon);
  }

  Future<void> _refreshFfi() async {
    final ffi = _ffi.getCounter();
    if (!mounted) return;
    setState(() => _ffiCounter = ffi);
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

  Future<void> _resetMc() async {
    final res = await _channels.mcReset();
    setState(() => _methodChannelCounter = res);
  }

  Future<void> _incPigeon() async {
    final res = await _channels.pigeonIncrement(1);
    setState(() => _pigeon = res);
  }

  Future<void> _resetPigeon() async {
    await _channels.pigeonReset();
    final res = await _channels.pigeonGetCounter();
    setState(() => _pigeon = res);
  }

  Future<void> _incFfi() async {
    final res = _ffi.increment(1);
    setState(() => _ffiCounter = res);
  }

  Future<void> _resetFfi() async {
    final res = _ffi.reset();
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

  Widget _statusTable() {
    return Table(
      columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
      children: [
        TableRow(children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('MethodChannel')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(_fmtCounter(_methodChannelCounter)),
          ),
        ]),
        TableRow(children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('Pigeon HostApi')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(_fmtCounter(_pigeon)),
          ),
        ]),
        TableRow(children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('FFI')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(_fmtCounter(_ffiCounter)),
          ),
        ]),
        TableRow(children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('EventChannel')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('events=${_eventLatencies.length}'),
          ),
        ]),
      ],
    );
  }

  Widget _tableCell(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: child,
      );

  Widget _matrix() {
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        const TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text('方式', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text('傳給原生', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text('監聽原生', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text('其他 / Perf', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ]),
        TableRow(children: [
          _tableCell(const Text('手寫 (Platform Channel)')),
          _tableCell(Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ElevatedButton(onPressed: _running ? null : _incMc, child: const Text('MethodChannel +1')),
              ElevatedButton(onPressed: _running ? null : _refreshMethodChannel, child: const Text('刷新')),
              ElevatedButton(onPressed: _running ? null : _resetMc, child: const Text('重置')),
            ],
          )),
          _tableCell(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('EventChannel：${_eventLatencies.length} 筆'),
              if (_eventLatencies.isNotEmpty) Text('最新延遲(ms)：${_eventLatencies.last}'),
            ],
          )),
          _tableCell(Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ElevatedButton(onPressed: _running ? null : _echoBasic, child: const Text('Basic Echo')),
              ElevatedButton(
                onPressed: _running
                    ? null
                    : () => _runPerf(
                          'MethodChannel x2000',
                          () => _perfBatch('MethodChannel', () => _channels.mcIncrement(1)),
                        ),
                child: const Text('MethodChannel x2000'),
              ),
            ],
          )),
        ]),
        TableRow(children: [
          _tableCell(const Text('Pigeon (HostApi)')),
          _tableCell(Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ElevatedButton(onPressed: _running ? null : _incPigeon, child: const Text('Pigeon +1')),
              ElevatedButton(onPressed: _running ? null : _refreshPigeon, child: const Text('刷新')),
              ElevatedButton(onPressed: _running ? null : _resetPigeon, child: const Text('重置')),
            ],
          )),
          _tableCell(const Text('（共用 EventChannel）')),
          _tableCell(Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ElevatedButton(
                onPressed: _running
                    ? null
                    : () => _runPerf(
                          'Pigeon x2000',
                          () => _perfBatch('Pigeon', () => _channels.pigeonIncrement(1)),
                        ),
                child: const Text('Pigeon x2000'),
              ),
            ],
          )),
        ]),
        TableRow(children: [
          _tableCell(const Text('FFI')),
          _tableCell(Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ElevatedButton(onPressed: _running ? null : _incFfi, child: const Text('FFI +1')),
              ElevatedButton(onPressed: _running ? null : _refreshFfi, child: const Text('刷新')),
              ElevatedButton(onPressed: _running ? null : _resetFfi, child: const Text('重置')),
            ],
          )),
          _tableCell(const Text('（無監聽）')),
          _tableCell(Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ElevatedButton(
                onPressed: _running
                    ? null
                    : () => _runPerf('FFI x2000', () => _perfBatch('FFI', () async => _ffi.increment(1))),
                child: const Text('FFI x2000'),
              ),
            ],
          )),
        ]),
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
            _section('當前狀態 (分通道)', [
              _statusTable(),
              const SizedBox(height: 4),
              Text('事件延遲樣本數：${_eventLatencies.length}'),
            ]),
            _section('矩陣操作（方式 x 通道類型）', [
              _matrix(),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _running ? null : _resetAll, child: const Text('全部重置')),
              const SizedBox(height: 8),
              Text(_perfLog),
            ]),
          ],
        ),
      ),
    );
  }
}

