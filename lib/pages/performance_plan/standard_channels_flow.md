

## Client

```dart
class DeviceApiPlatformChannels {
  static const MethodChannel _channel = MethodChannel('x');

  Future<DeviceInfo> getDeviceInfo() async {
    final obj = (await _channel.invokeMethod<Map<Object?, Object?>>('getDeviceInfo'))!;
    return DeviceInfo(
      androidVersion: obj['v'] as String,
      model: obj['m'] as String? ?? 'Unknown',
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
```

## Host

```kotlin
MethodChannel(messenger, "x").setMethodCallHandler { call, result ->
    val version = "${android.os.Build.VERSION.RELEASE} ${android.os.Build.VERSION.SDK_INT}"
    val model = android.os.Build.MODEL ?: "Unknown"
    val deviceInfo = mapOf("v" to version, "m" to model)
    result.success(deviceInfo)
}
```
