import 'package:flutter/material.dart';

class PerformancePlanPage extends StatelessWidget {
  const PerformancePlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Plan Page')
      ),
    );
  }
}

// ignore: unused_element
const _pigeonCode = '''// interface
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'com.wjprogramer.flutter_pigeon_example',
    dartOut: 'lib/pigeon/messages.dart',
    kotlinOut: 'android/app/src/main/kotlin/com/wjprogramer/flutter_pigeon_example/pigeons/Messages.kt',
    kotlinOptions: KotlinOptions(package: 'com.wjprogramer.flutter_pigeon_example.pigeons'),
  ),
)

class DeviceInfo {
  DeviceInfo({
    required this.androidVersion, 
    required this.model,
  });

  String androidVersion;
  String model;
}

@HostApi()
abstract class DeviceApi {
  DeviceInfo getDeviceInfo();
}

// host
class DeviceApiImpl : DeviceApi {
    override fun getDeviceInfo(): DeviceInfo {
        val version = "Android \${Build.VERSION.RELEASE} (API \${Build.VERSION.SDK_INT})"
        val model = Build.MODEL ?: "Unknown"
        return DeviceInfo(version, model)
    }
}''';

// ignore: unused_element
const _standardCode = '''// client
class D {
  static const _c = MethodChannel('x');

  Future<DeviceInfo> getDeviceInfo() async {
    final obj = (await _c.invokeMethod<Map<Object?, Object?>>('getDeviceInfo'))!;
    return DeviceInfo(
      version: obj['version'] as String,
      model: obj['model'] as String,
    );
  }
}

class DeviceInfo {
  DeviceInfo({
    required this.version,
    required this.model,
  });

  final String version;
  String model;
}

// host
MethodChannel(binaryMessenger, "x").setMethodCallHandler { call, result ->
    when (call.method) {
        "getDeviceInfo" -> {
            result.success(
                mapOf(
                    "version" to "\${Build.VERSION.RELEASE} \${Build.VERSION.SDK_INT}",
                    "model" to Build.MODEL
                )
            )
        }
        else -> result.notImplemented()
    }
}''';
