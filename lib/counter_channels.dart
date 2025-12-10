import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pigeon_slides/pigeons/counter.g.dart';

Counter _decodeCounter(dynamic data) {
  if (data == null) {
    throw PlatformException(code: 'null-payload', message: 'Counter payload is null');
  }
  if (data is Counter) return data;
  if (data is Map) {
    final value = data['value'];
    return Counter(
      value: value is int ? value : (value as num).toInt(),
      updatedAt: (data['updatedAt'] as num?)?.toInt(),
      source: data['source'] as String?,
    );
  }
  throw PlatformException(code: 'bad-payload', message: 'Unsupported payload for Counter: ${data.runtimeType}');
}

class CounterChannels {
  CounterChannels({
    MethodChannel? methodChannel,
    BasicMessageChannel<dynamic>? basicMessageChannel,
    EventChannel? eventChannel,
    CounterHostApi? pigeonApi,
  })  : _methodChannel = methodChannel ?? const MethodChannel('demo.counter.method'),
        _basicMessageChannel = basicMessageChannel ??
            const BasicMessageChannel<dynamic>('demo.counter.basic', StandardMessageCodec()),
        _eventChannel = eventChannel ?? const EventChannel('demo.counter.events'),
        _pigeonApi = pigeonApi ?? CounterHostApi();

  final MethodChannel _methodChannel;
  final BasicMessageChannel<dynamic> _basicMessageChannel;
  final EventChannel _eventChannel;
  final CounterHostApi _pigeonApi;

  // MethodChannel-based
  Future<Counter> mcGetCounter() async => _decodeCounter(await _methodChannel.invokeMethod('getCounter'));

  Future<Counter> mcIncrement(int delta) async =>
      _decodeCounter(await _methodChannel.invokeMethod('increment', {'delta': delta}));

  Future<Counter> mcReset() async => _decodeCounter(await _methodChannel.invokeMethod('reset'));

  // Pigeon-based
  Future<Counter> pigeonGetCounter() => _pigeonApi.getCounter();

  Future<Counter> pigeonIncrement(int delta) => _pigeonApi.increment(delta);

  Future<void> pigeonReset() => _pigeonApi.reset();

  // BasicMessageChannel echo
  Future<dynamic> basicEcho(dynamic payload) => _basicMessageChannel.send(payload);

  // Events
  Stream<Counter> events() => _eventChannel.receiveBroadcastStream().map(_decodeCounter);
}

