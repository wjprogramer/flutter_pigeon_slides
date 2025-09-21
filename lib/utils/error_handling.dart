import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/theme/theme.dart';

class ErrorHandlingAtDiffMethod {
  ErrorHandlingAtDiffMethod._();

  static Widget atPigeon = Text.rich(
    TextSpan(
      text:
          '''## Caught error: ''',
      children: [
        TextSpan(text: '''PlatformException''', style: TextStyle(
          color: MyColors.highlight2,
        )),
        TextSpan(text: '''(Exception, java.lang.Exception: '''),
        TextSpan(text: '''測試錯誤處理''', style: TextStyle(
          color: MyColors.highlight3,
        )),
        TextSpan(text: ''', Cause: null, Stacktrace: java.lang.Exception: 測試錯誤處理
	at com.wjprogramer.flutter_pigeon_example.pigeons_impl.messages.DeviceApiImpl.getDeviceInfo('''),
        TextSpan(
          text: 'DeviceApiImpl.kt:9',
          style: TextStyle(color: MyColors.highlight),
        ),
        TextSpan(
          text: ''')
	at com.wjprogramer.flutter_pigeon_example.pigeons.messages.DeviceApi\$Companion.setUp\$lambda\$2\$lambda\$1(Messages.kt:163)
	at com.wjprogramer.flutter_pigeon_example.pigeons.messages.DeviceApi\$Companion.\$r8\$lambda\$0vxyr_Q27Dtyrxv5FHtJrDIsIBA(Unknown Source:0)
	at com.wjprogramer.flutter_pigeon_example.pigeons.messages.DeviceApi\$Companion\$\$ExternalSyntheticLambda0.onMessage(D8\$\$SyntheticClass:0)
	at io.flutter.plugin.common.BasicMessageChannel\$IncomingMessageHandler.onMessage(BasicMessageChannel.java:261)
	at io.flutter.embedding.engine.dart.DartMessenger.invokeHandler(DartMessenger.java:292)
	at io.flutter.embedding.engine.dart.DartMessenger.lambda\$dispatchMessageToQueue\$0\$io-flutter-embedding-engine-dart-DartMessenger(DartMessenger.java:319)
	at io.
## StackTrace:
#0      DeviceApi.getDeviceInfo (package:flutter_pigeon_example/''',
        ),
        TextSpan(
          text: '''pigeon/messages.dart:144:7''',
          style: TextStyle(color: MyColors.highlight),
        ),
        TextSpan(
          text: ''')
<asynchronous suspension>
#1      _HomePageState._loadInfo (package:flutter_pigeon_example/main.dart:84:20)
<asynchronous suspension>''',
        ),
      ],
    ),

    style: TextStyle(
      color: Colors.grey,
    ),
  );

  static Widget standardPlatformChannel = Text.rich(
    TextSpan(
      text:
      '''## Caught error: ''',
      children: [
        TextSpan(text: '''MissingPluginException''', style: TextStyle(
          color: MyColors.highlight2,
        )),
        TextSpan(text: '''(No implementation found for method getDeviceInfo on channel samples.flutter.dev/device_api_platform_channel)
## StackTrace:
#0      MethodChannel._invokeMethod (package:flutter/src/services/'''),
        TextSpan(text: '''platform_channel.dart:368:7''',

          style: TextStyle(color: MyColors.highlight),
        ),
        TextSpan(text: ''')
<asynchronous suspension>
#1      DeviceApiPlatformChannels.getDeviceInfo (package:flutter_pigeon_example/standard_platform_channels/device_api_platform_channels.dart:10:32)
<asynchronous suspension>
#2      _HomePageState._loadInfo (package:flutter_pigeon_example/main.dart:86:20)
<asynchronous suspension>'''),
        TextSpan(text: ''''''),
        TextSpan(text: ''''''),
      ],
    ),
      style: TextStyle(
        color: Colors.grey,
      ),
  );
}
