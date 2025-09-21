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
    return [
      FormattedCode(
        code: '''// 0 設定

// Usage
final info = await DeviceApi().getDeviceInfo();
''',
      ),
    ];
  }
}

class PigeonBasicCode_Host {
  PigeonBasicCode_Host._();

  static List<FormattedCode> formattedCode() {
    return [
      FormattedCode(
        code: '''class DeviceApiImpl : DeviceApi {
    override fun getDeviceInfo(): DeviceInfo {
        val version = "Android \${Build.VERSION.RELEASE} (API \${Build.VERSION.SDK_INT})"
        val model = Build.MODEL ?: "Unknown"
        return DeviceInfo(version, model)
    }
}

private val deviceApiImpl = DeviceApiImpl()

DeviceApi.setUp(messenger, deviceApiImpl)''',
      ),
    ];
  }
}

class PigeonGeneratedCode_Client {
  PigeonGeneratedCode_Client._();

  static List<FormattedCode> importCode() {
    return [
      FormattedCode(
        code: '''import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';''',
      ),
    ];
  }

  static List<FormattedCode> platformError() {
    return [
      FormattedCode(
        code: '''PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "\$channelName".',
  );
}''',
      ),
    ];
  }

  static List<FormattedCode> deepEqualsCode() {
    return [
      FormattedCode(
        code: '''bool _deepEquals(Object? a, Object? b) {
  if (a is List && b is List) {
    return a.length == b.length &&
        a.indexed
        .every(((int, dynamic) item) => _deepEquals(item.\$2, b[item.\$1]));
  }
  if (a is Map && b is Map) {
    return a.length == b.length && a.entries.every((MapEntry<Object?, Object?> entry) =>
        (b as Map<Object?, Object?>).containsKey(entry.key) &&
        _deepEquals(entry.value, b[entry.key]));
  }
  return a == b;
}''',
      ),
    ];
  }

  static List<FormattedCode> deviceInfoCode() {
    return [
      FormattedCode(
        code: '''class DeviceInfo {
  DeviceInfo({required this.androidVersion, required this.model,});

  String androidVersion;
  String model;

  List<Object?> _toList() {
    return <Object?>[ androidVersion, model, ];
  }

  Object encode() => _toList();

  static DeviceInfo decode(Object result) {
    result as List<Object?>;
    return DeviceInfo(
      androidVersion: result[0]! as String,
      model: result[1]! as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! DeviceInfo || other.runtimeType != runtimeType) return false;
    if (identical(this, other)) return true;
    return _deepEquals(encode(), other.encode());
  }

  @override
  int get hashCode => Object.hashAll(_toList());
}''',
      ),
    ];
  }

  static List<FormattedCode> codecCode() {
    return [
      FormattedCode(
        code: '''class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    }    else if (value is DeviceInfo) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129: 
        return DeviceInfo.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}''',
      ),
    ];
  }

  static List<FormattedCode> deviceApiCode() {
    return [
      FormattedCode(
        code: '''class DeviceApi {
  DeviceApi({BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.\$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  final String pigeonVar_messageChannelSuffix;

  Future<DeviceInfo> getDeviceInfo() async {
    // ...
  }
}''',
      ),
      FormattedCode(
        code: '''class DeviceApi {
  DeviceApi(/* ignore */);
  
  // properties

  Future<DeviceInfo> getDeviceInfo() async {
    // ...
  }
}''',
      ),
      FormattedCode(
        code: '''class DeviceApi {
  DeviceApi(/* ignore */);
  
  // properties

  Future<DeviceInfo> getDeviceInfo() async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.com.wjprogramer.flutter_pigeon_example.DeviceApi.getDeviceInfo\$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(null);
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_sendFuture as List<Object?>?;
  }
}''',
      ),
      FormattedCode(
        code: '''class DeviceApi {
  DeviceApi(/* ignore */);
  
  // properties

  Future<DeviceInfo> getDeviceInfo() async {
    // create channel and send message
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
  }
}''',
      ),
      FormattedCode(
        code: '''class DeviceApi {
  DeviceApi(/* ignore */);
  
  // properties

  Future<DeviceInfo> getDeviceInfo() async {
    // create channel and send message
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(code: 'null-error', message: 'Host platform returned null value for non-null return value.');
    } else {
      return (pigeonVar_replyList[0] as DeviceInfo?)!;
    }
  }
}''',
        highlightedLines: List.generate(288 - 276 + 1, (i) => i + 276 - 268),
      ),
      FormattedCode(
        code: '''class DeviceApi {
  DeviceApi(/* ignore */);
  
  // properties

  Future<DeviceInfo> getDeviceInfo() async {
    // create channel and send message
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(code: 'null-error', message: 'Host platform returned null value for non-null return value.');
    } else {
      return (pigeonVar_replyList[0] as DeviceInfo?)!;
    }
  }
}''',
      ),
    ];
  }
}

class PigeonGeneratedCode_Host {
  PigeonGeneratedCode_Host._();

  static List<FormattedCode> importCode() {
    return [
      FormattedCode(
        code: '''import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer''',
      ),
    ];
  }

  static List<FormattedCode> errorCode() {
    return [
      FormattedCode(
        code: '''class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()''',
      ),
    ];
  }

  static List<FormattedCode> codecCode() {
    return [
      FormattedCode(
        code: '''private open class MessagesPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DeviceInfo.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is DeviceInfo -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}''',
      ),
      FormattedCode(
        code: '''private open class MessagesPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DeviceInfo.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is DeviceInfo -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}''',
        highlightedLines: [],
      ),
    ];
  }

  static List<FormattedCode> deviceInfoCode() {
    return [
      FormattedCode(
        code: '''data class DeviceInfo (
  val androidVersion: String,
  val model: String
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): DeviceInfo {
      val androidVersion = pigeonVar_list[0] as String
      val model = pigeonVar_list[1] as String
      return DeviceInfo(androidVersion, model)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      androidVersion,
      model,
    )
  }
  override fun equals(other: Any?): Boolean {
    if (other !is DeviceInfo) {
      return false
    }
    if (this === other) {
      return true
    }
    return MessagesPigeonUtils.deepEquals(toList(), other.toList())  }

  override fun hashCode(): Int = toList().hashCode()
}''',
      ),
    ];
  }

  static List<FormattedCode> pigeonUtils() {
    return [
      FormattedCode(
        code: '''private object MessagesPigeonUtils {
  fun wrapResult(result: Any?): List<Any?> {
    return listOf(result)
  }
  fun wrapError(exception: Throwable): List<Any?> {
    return if (exception is FlutterError) {
      listOf(exception.code, exception.message, exception.details)
    } else {
      listOf(
        exception.javaClass.simpleName, exception.toString(),
        "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
      )
    }
  }
  fun deepEquals(a: Any?, b: Any?): Boolean {
    if (a is ByteArray && b is ByteArray) return a.contentEquals(b)
    if (a is IntArray && b is IntArray) return a.contentEquals(b)
    if (a is LongArray && b is LongArray) return a.contentEquals(b)
    if (a is DoubleArray && b is DoubleArray) return a.contentEquals(b)
    if (a is Array<*> && b is Array<*>) {
      return a.size == b.size &&
          a.indices.all{ deepEquals(a[it], b[it]) }
    }
    if (a is List<*> && b is List<*>) { /* Compare size and elements. */ }
    if (a is Map<*, *> && b is Map<*, *>) { /* Compare size, keys, and values. */ }
    return a == b
  }    
}''',
      ),
    ];
  }

  static List<FormattedCode> deviceApiCode() {
    return [FormattedCode(code: '''interface DeviceApi {
  fun getDeviceInfo(): DeviceInfo

  companion object {
    val codec: MessageCodec<Any?> by lazy {
      MessagesPigeonCodec()
    }
    @JvmOverloads
    fun setUp(binaryMessenger: BinaryMessenger, api: DeviceApi?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".\$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.com.wjprogramer.flutter_pigeon_example.DeviceApi.getDeviceInfo\$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.getDeviceInfo())
            } catch (exception: Throwable) {
              MessagesPigeonUtils.wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}''')];
  }

  static List<FormattedCode> xxxCode31() {
    return [FormattedCode(code: '''''')];
  }

  static List<FormattedCode> xxxCode3133() {
    return [FormattedCode(code: '''''')];
  }

  static List<FormattedCode> xxxCode31331() {
    return [FormattedCode(code: '''''')];
  }

  static List<FormattedCode> xxxCode31332() {
    return [FormattedCode(code: '''''')];
  }

  static List<FormattedCode> xxxCode31333() {
    return [FormattedCode(code: '''''')];
  }

  static List<FormattedCode> xxxCode31334() {
    return [FormattedCode(code: '''''')];
  }
}
