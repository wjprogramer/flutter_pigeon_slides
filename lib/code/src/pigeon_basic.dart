part of '../code.dart';

// ignore_for_file: camel_case_types

class PigeonBasicCode_Interface {
  PigeonBasicCode_Interface._();

  static List<FormattedCode> formattedCode() {
    return [
      FormattedCode(
        code: '''@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'com.wjprogramer.flutter_pigeon_example',
    dartOut: 'lib/pigeon/messages.dart',
    kotlinOut: 'android/app/src/main/kotlin/com/wjprogramer/flutter_pigeon_example/pigeons/messages/Messages.kt',
    kotlinOptions: KotlinOptions(package: 'com.wjprogramer.flutter_pigeon_example.pigeons.messages'),
  ),
)''',
      ),
      FormattedCode(
        code: '''@ConfigurePigeon(
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
}''',
      ),
      FormattedCode(
        code: '''@ConfigurePigeon(
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
}''',
      ),
    ];
  }
}

class PigeonBasicCode_Client {
  PigeonBasicCode_Client._();

  static List<FormattedCode> formattedCode() {
    return [FormattedCode(code: '''// 0 設定

// Usage
final info = await DeviceApi().getDeviceInfo();
''')];
  }
}
