
/// 回傳 Pigeon 與 Method Channel 實作的程式碼行數差異
/// (僅計算 User 需要手打的部分，不包含 Pigeon 自動產生的程式碼)
int getPigeonAndPlatformMethodChannelDiffCount() {
  final pigeonLines = _pigeonCode.split('\n').length;
  final methodChannelLines = _methodChannelCode.split('\n').length;
  return pigeonLines - methodChannelLines;
}

const _methodChannelCode = '''class DeviceApiPlatformChannels {
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
  DeviceInfo({
    required this.androidVersion, 
    required this.model,
  });

  String androidVersion;
  String model;
}

class DeviceApiPlatformChannel {
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
}''';

const _pigeonCode = '''@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'com.wjprogramer.flutter_pigeon_example',
    dartOut: 'lib/pigeon/messages.dart',
    kotlinOut: 'android/app/src/main/kotlin/com/wjprogramer/flutter_pigeon_example/pigeons/messages/Messages.kt',
    kotlinOptions: KotlinOptions(package: 'com.wjprogramer.flutter_pigeon_example.pigeons.messages'),
  ),
)

class DeviceInfo {
  DeviceInfo({required this.androidVersion, required this.model});

  String androidVersion;
  String model;
}

@HostApi()
abstract class DeviceApi {
  DeviceInfo getDeviceInfo();
}

class DeviceApiImpl : DeviceApi {
    override fun getDeviceInfo(): DeviceInfo {
        val version = "Android \${Build.VERSION.RELEASE} (API \${Build.VERSION.SDK_INT})"
        val model = Build.MODEL ?: "Unknown"
        return DeviceInfo(version, model)
    }
}''';
