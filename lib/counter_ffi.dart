import 'dart:ffi' as ffi;

import 'package:flutter_pigeon_slides/pigeons/counter.g.dart';

typedef _GetCounterNative = ffi.Int64 Function();
typedef _GetCounterDart = int Function();
typedef _AddCounterNative = ffi.Int64 Function(ffi.Int64 delta);
typedef _AddCounterDart = int Function(int delta);
typedef _ResetCounterNative = ffi.Int64 Function();
typedef _ResetCounterDart = int Function();
typedef _GetUpdatedAtNative = ffi.Int64 Function();
typedef _GetUpdatedAtDart = int Function();

class CounterFfi {
  CounterFfi({ffi.DynamicLibrary? library}) : _lib = library ?? ffi.DynamicLibrary.process() {
    _getCounter = _lib.lookupFunction<_GetCounterNative, _GetCounterDart>('get_counter');
    _addCounter = _lib.lookupFunction<_AddCounterNative, _AddCounterDart>('add_counter');
    _resetCounter = _lib.lookupFunction<_ResetCounterNative, _ResetCounterDart>('reset_counter');
    _getUpdatedAt = _lib.lookupFunction<_GetUpdatedAtNative, _GetUpdatedAtDart>('get_counter_updated_at');
  }

  final ffi.DynamicLibrary _lib;
  late final _GetCounterDart _getCounter;
  late final _AddCounterDart _addCounter;
  late final _ResetCounterDart _resetCounter;
  late final _GetUpdatedAtDart _getUpdatedAt;

  Counter getCounter() => Counter(
        value: _getCounter(),
        updatedAt: _getUpdatedAt(),
        source: 'ffi',
      );

  Counter increment(int delta) => Counter(
        value: _addCounter(delta),
        updatedAt: _getUpdatedAt(),
        source: 'ffi',
      );

  Counter reset() => Counter(
        value: _resetCounter(),
        updatedAt: _getUpdatedAt(),
        source: 'ffi',
      );
}

