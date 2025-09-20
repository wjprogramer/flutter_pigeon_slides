part of '../code.dart';

// ignore_for_file: camel_case_types

class PlatformChannelMethodChannelCode_Client {
  PlatformChannelMethodChannelCode_Client._();

  static List<FormattedCode> formattedCode() {
    return [
      FormattedCode(
        code: '''class DeviceApiPlatformChannels {
  
}''',
      ),
      FormattedCode(
        code: '''class DeviceApiPlatformChannels {
  static const MethodChannel _channel = MethodChannel('samples.flutter.dev/device_api_platform_channel');
}''',
        highlightedLines: [1],
      ),
      FormattedCode(
        code: '''class DeviceApiPlatformChannels {
  static const MethodChannel _channel = MethodChannel('samples.flutter.dev/device_api_platform_channel');

  Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfoJsonObj = (await _channel.invokeMethod<Map<Object?, Object?>>('getDeviceInfo'))!;
  }
}''',
        highlightedLines: [3, 4, 5],
      ),
      FormattedCode(
        code: '''class DeviceApiPlatformChannels {
  static const MethodChannel _channel = MethodChannel('samples.flutter.dev/device_api_platform_channel');

  Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfoJsonObj = (await _channel.invokeMethod<Map<Object?, Object?>>('getDeviceInfo'))!;
    return DeviceInfo(
      androidVersion: deviceInfoJsonObj['version'] as String? ?? 'Unknown',
      model: deviceInfoJsonObj['model'] as String? ?? 'Unknown',
    );
  }
}''',
        highlightedLines: List.generate(40 - 37 + 1, (index) => index + (36 - 32 + 1)),
      ),
      FormattedCode(
        code: '''class DeviceApiPlatformChannels {
  static const MethodChannel _channel = MethodChannel('samples.flutter.dev/device_api_platform_channel');

  Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfoJsonObj = (await _channel.invokeMethod<Map<Object?, Object?>>('getDeviceInfo'))!;
    return DeviceInfo(
      androidVersion: deviceInfoJsonObj['version'] as String? ?? 'Unknown',
      model: deviceInfoJsonObj['model'] as String? ?? 'Unknown',
    );
  }
}

class DeviceInfo {
  DeviceInfo({required this.androidVersion, required this.model});
  String androidVersion; String model;
}

// Usage
final info = await DeviceApiPlatformChannels().getDeviceInfo();''',
      ),
    ];
  }
}

class PlatformChannelMethodChannelCode_Host {
  PlatformChannelMethodChannelCode_Host._();

  static List<FormattedCode> formattedCode() {
    return [_a, _b, _c, _d, _e, _f];
  }

  static final _a = FormattedCode(
    code: '''class DeviceApiPlatformChannel {
}''',
  );

  static final _b = FormattedCode(
    code: '''class DeviceApiPlatformChannel {
    companion object {
        const val CHANNEL = "samples.flutter.dev/device_api_platform_channel"
    }
}''',
    highlightedLines: [1, 2, 3],
  );

  static final _c = FormattedCode(
    code: '''class DeviceApiPlatformChannel {
    companion object {
        const val CHANNEL = "samples.flutter.dev/device_api_platform_channel"
    }

    fun init(binaryMessenger: BinaryMessenger) {
        MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                else -> result.notImplemented()
            }
        }
    }
}''',
    highlightedLines: [5, 6, 7, 8, 9, 10, 11],
  );

  static final _d = FormattedCode(
    code: '''class DeviceApiPlatformChannel {
    companion object {
        const val CHANNEL = "samples.flutter.dev/device_api_platform_channel"
    }

    fun init(binaryMessenger: BinaryMessenger) {
        MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceInfo" -> {
                }
                else -> result.notImplemented()
            }
        }
    }
}''',
    highlightedLines: [8, 9],
  );

  static final _e = FormattedCode(
    code: '''class DeviceApiPlatformChannel {
    companion object {
        const val CHANNEL = "samples.flutter.dev/device_api_platform_channel"
    }

    fun init(binaryMessenger: BinaryMessenger) {
        MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceInfo" -> {
                    val version = "Android \${android.os.Build.VERSION.RELEASE} (API \${android.os.Build.VERSION.SDK_INT})"
                    val model = android.os.Build.MODEL ?: "Unknown"
                    val deviceInfo = mapOf("version" to version, "model" to model)
                    result.success(deviceInfo)
                }
                else -> result.notImplemented()
            }
        }
    }
}''',
    highlightedLines: [9, 10, 11, 12, 13],
  );

  static final _f = FormattedCode(
    code: '''class DeviceApiPlatformChannel {
    companion object {
        const val CHANNEL = "samples.flutter.dev/device_api_platform_channel"
    }

    fun init(binaryMessenger: BinaryMessenger) {
        MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceInfo" -> {
                    val version = "Android \${android.os.Build.VERSION.RELEASE} (API \${android.os.Build.VERSION.SDK_INT})"
                    val model = android.os.Build.MODEL ?: "Unknown"
                    val deviceInfo = mapOf("version" to version, "model" to model)
                    result.success(deviceInfo)
                }
                else -> result.notImplemented()
            }
        }
    }
}''',
    highlightedLines: [],
  );
}
