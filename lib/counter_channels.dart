import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pigeon_slides/pigeons/counter.g.dart';

Counter _decodeCounter(dynamic data) {
  if (data == null) {
    throw PlatformException(code: 'null-payload', message: 'Counter payload is null');
  }
  if (data is Counter) return data;
  if (data is Map) {
    final value = data['value'] ?? data['v'];
    final ts = data['updatedAt'] ?? data['t'];
    return Counter(
      value: value is int ? value : (value as num).toInt(),
      updatedAt: (ts as num?)?.toInt(),
    );
  }
  throw PlatformException(code: 'bad-payload', message: 'Unsupported payload for Counter: ${data.runtimeType}');
}

class CounterChannels {
  CounterChannels({
    MethodChannel? methodChannel,
    MethodChannel? methodChannelLongKeys,
    BasicMessageChannel<dynamic>? basicMessageChannel,
    EventChannel? eventChannel,
    CounterHostApi? pigeonApi,
  })  : _methodChannel = methodChannel ?? const MethodChannel('demo.counter.method'),
        _methodChannelLong = methodChannelLongKeys ?? const MethodChannel('demo.counter.method.long'),
        _basicMessageChannel = basicMessageChannel ??
            const BasicMessageChannel<dynamic>('demo.counter.basic', StandardMessageCodec()),
        _eventChannel = eventChannel ?? const EventChannel('demo.counter.events'),
        _pigeonApi = pigeonApi ?? CounterHostApi();

  final MethodChannel _methodChannel;
  final MethodChannel _methodChannelLong;
  final BasicMessageChannel<dynamic> _basicMessageChannel;
  final EventChannel _eventChannel;
  final CounterHostApi _pigeonApi;

  // MethodChannel-based
  Future<Counter> mcGetCounter() async => _decodeCounter(await _methodChannel.invokeMethod('getCounter'));

  Future<Counter> mcIncrement(int delta) async =>
      _decodeCounter(await _methodChannel.invokeMethod('increment', {'delta': delta}));

  Future<Counter> mcReset() async => _decodeCounter(await _methodChannel.invokeMethod('reset'));

  // MethodChannel-based (long keys payload)
  Future<Counter> mcLongGetCounter() async =>
      _decodeCounter(await _methodChannelLong.invokeMethod('getCounter'));

  Future<Counter> mcLongIncrement(int delta) async =>
      _decodeCounter(await _methodChannelLong.invokeMethod('increment', {'delta': delta}));

  Future<Counter> mcLongReset() async =>
      _decodeCounter(await _methodChannelLong.invokeMethod('reset'));

  // Pigeon-based
  Future<Counter> pigeonGetCounter() => _pigeonApi.getCounter();

  Future<Counter> pigeonIncrement(int delta) => _pigeonApi.increment(delta);

  Future<void> pigeonReset() => _pigeonApi.reset();

  // BasicMessageChannel echo
  Future<dynamic> basicEcho(dynamic payload) => _basicMessageChannel.send(payload);

  // Events
  Stream<Counter> events() => _eventChannel.receiveBroadcastStream().map(_decodeCounter);

  // Pigeon EventChannelApi
  Stream<Counter> pigeonEvents({String instanceName = ''}) => watch(instanceName: instanceName);

  // FlutterApi from host -> flutter
  void setupFlutterApi(CounterFlutterApi api) {
    CounterFlutterApi.setUp(api);
  }

  // Native -> Flutter burst emit (for perf test)
  Future<void> mcEmitEvents(int count) => _methodChannel.invokeMethod('emitMethodEvents', {'count': count});

  // Pigeon EventChannelApi burst
  Future<void> pigeonEmitWatchEvents(int count) =>
      _methodChannel.invokeMethod('emitPigeonWatchEvents', {'count': count});

  // Pigeon FlutterApi burst
  Future<void> pigeonEmitFlutterEvents(int count) =>
      _methodChannel.invokeMethod('emitPigeonFlutterEvents', {'count': count});
}

