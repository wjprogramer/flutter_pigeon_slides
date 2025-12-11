import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/pigeons/counter.g.dart',
    swiftOut: 'macos/Runner/PigeonCounter.swift',
    kotlinOut: 'android/app/src/main/kotlin/com/wjprogramer/flutter_pigeon_slides/Counter.kt',
    kotlinOptions: KotlinOptions(package: 'com.wjprogramer.flutter_pigeon_slides'),
    swiftOptions: SwiftOptions(),
    dartPackageName: 'flutter_pigeon_slides',
  ),
)
class Counter {
  Counter({
    required this.value,
    this.updatedAt,
  });

  int value;
  int? updatedAt;
}

@HostApi()
abstract class CounterHostApi {
  Counter getCounter();
  Counter increment(int delta);
  void reset();
}

@EventChannelApi()
abstract class CounterEventApi {
  Counter watch();
}

@FlutterApi()
abstract class CounterFlutterApi {
  void onCounter(Counter counter);
}

