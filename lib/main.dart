import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/pages/menu/menu_page.dart';
import 'package:flutter_pigeon_slides/theme/theme.dart';
import 'package:flutter_pigeon_slides/utils/error_handling.dart';
import 'package:flutter_pigeon_slides/utils/why_message_channel_suffix_exist.dart';
import 'package:slick_slides/slick_slides.dart';

import 'code/code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SlickSlides.initialize();

  runApp(const MyApp());
}

const _defaultTransition = SlickFadeTransition(color: Colors.black);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slick Slides Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _isHover = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SlideDeck(
          slides: [
            FullScreenImageSlide(
              image: const AssetImage('assets/logo-background.jpg'),
              title: 'Pigeon 介紹',
              subtitle: '型別安全、維護性高與原生溝通',
              alignment: const Alignment(0.6, 0.0),
              theme: const SlideThemeData.darkAlt(),
              transition: _defaultTransition,
            ),
            BulletsSlide.rich(
              theme: const SlideThemeData.dark(),
              title: TextSpan(text: '與原生溝通的方式'),
              bulletByBullet: true,
              bullets: [
                TextSpan(
                  text: '1. Standard Platform Channels API\n',
                  children: [
                    TextSpan(
                      text: '       (MethodChannel / EventChannel / BasicMessageChannel)',
                      style: TextStyle(fontSize: 25, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                TextSpan(text: '2. Pigeon package'),
                TextSpan(
                  text: '3. JS interoperability or the package:web library',
                  children: [
                    TextSpan(
                      text: ' (Web 專用)\n',
                      style: TextStyle(color: MyColors.highlight),
                    ),
                    TextSpan(
                      text: '      後續除非特別提，不然都只會包含前兩者',
                      style: TextStyle(fontSize: 25, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
              transition: _defaultTransition,
              // https://docs.flutter.dev/platform-integration/platform-channels#overview
              notes:
                  '官方 Overview 就介紹三種，不確定有沒有第四種，搜不到\n\n'
                  ''
                  'Web: dart:js_interop\n\n' // https://dart.dev/interop/js-interop
                  '',
            ),
            BulletsSlide(
              title: 'Platform Channels',
              image: const AssetImage('assets/PlatformChannels.png'),
              bullets: [
                '非同步傳遞訊息的機制，\n保持UI可反應',
                '可雙向溝通',
                // 注意是指 Channels，而非 pigeon，避免和後面的 pigeon 優點搞混，因此註解這行
                // '允許極少樣板程式碼開發',
                // On the client side, MethodChannel for Flutter enables sending messages that correspond to method calls.
                // On the platform side, MethodChannel for Android and FlutterMethodChannel for iOS enable receiving method calls and sending back a result.
                // These classes allow you to develop a platform plugin with very little boilerplate code.
              ],
              transition: _defaultTransition,
              notes:
                  'Messages are passed between the client (UI) and host (platform) using platform channels as illustrated in this diagram:\n\n' // https://docs.flutter.dev/platform-integration/platform-channels#architecture
                  ''
                  '在平台(Host)的主執行緒執行\n'
                  ' (Even though Flutter sends messages to and from Dart asynchronously, whenever you invoke a channel method, you must invoke that method on the platform\'s main thread. See the section on threading for more information.)\n\n'
                  ''
                  '可雙向溝通\n'
                  'If desired, method calls can also be sent in the reverse direction, with the platform acting as client to methods implemented in Dart. For a concrete example, check out the quick_actions plugin.',
            ),
            BulletsSlide(
              title: 'Data types support',
              bullets: ['編解碼都是使用 StandardMessageCodec'],
              transition: _defaultTransition,
              notes:
                  '都是使用 StandardMessageCodec:\n'
                  'The standard platform channel APIs and the Pigeon package use a standard message codec called StandardMessageCodec that supports efficient binary serialization of simple JSON-like values, such as booleans, numbers, Strings, byte buffers, Lists, and Maps. The serialization and deserialization of these values to and from messages happens automatically when you send and receive values.',
            ),
            PersonSlide(
              name: 'Client call Host',
              title: 'MethodChannel & HostApi',
              image: const AssetImage('assets/flutter_logo.webp'),
              transition: _defaultTransition,
            ),
            AnimatedCodeSlide(
              title: '使用 Platform Channels - Client',
              theme: MyThemes.codeTheme,
              formattedCode: PlatformChannelMethodChannelCode_Client.formattedCode(),
              notes: 'Create the Flutter platform client',
              transition: _defaultTransition,
            ),
            AnimatedCodeSlide(
              title: '使用 Platform Channels - Host',
              theme: MyThemes.codeTheme,
              formattedCode: PlatformChannelMethodChannelCode_Host.formattedCode(),
              // language: 'java', // 不支援
              notes: 'Create the Flutter platform Host',
              transition: _defaultTransition,
            ),
            AnimatedCodeSlide(
              title: '使用 Pigeon - Interface',
              theme: MyThemes.codeTheme,
              formattedCode: PigeonBasicCode_Interface.formattedCode(),
              transition: _defaultTransition,
              notes: '@ConfigurePigeon 裡面不能抽',
            ),
            BulletsSlide(
              title: '使用 Pigeon - Generate',
              bullets: [
                'dart run pigeons --input xxxx.dart',
                'for f in pigeons/*.dart; do dart run pigeons --input \$f; done',
                'make pigeon # Makefile',
                '設定 File Watchers，Save 時自動執行產生指令',
              ],
              transition: _defaultTransition,
              notes:
                  '🦄 小缺點: 多流程'
                  ''
                  'GPT: 👉 缺點：需要 codegen 流程（多一道 build 步驟）。\n\n'
                  ''
                  '但我個人覺得多一個流程，並不會影響什麼，後續會說明，包含錄製影片說明兩個平台的開發速度差異\n\n'
                  ''
                  '另外其他可以減緩的方式，透過 File Watchers，在 pigeons/ 底下的檔案被存檔的時候執行指令，'
                  '甚至我們也可以加入 CI/CD，每次都會跑一下 pigeon，如果發生 commit 上的變化，代表有 RD 改了 pigeon 卻沒修改 host code\n\n'
                  ''
                  '如果設了自動處理，這個就不會是缺點，因為有多人會僅單純因為 intl_utils auto save 要多跑一道指令而棄用呢?',
            ),
            AnimatedCodeSlide(
              title: '使用 Pigeon - Client',
              theme: MyThemes.codeTheme,
              formattedCode: PigeonBasicCode_Client.formattedCode(),
              transition: _defaultTransition,
              notes: '',
            ),
            AnimatedCodeSlide(
              title: '使用 Pigeon - Host',
              theme: MyThemes.codeTheme,
              formattedCode: PigeonBasicCode_Host.formattedCode(),
              transition: _defaultTransition,
              notes: '',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Client',
              theme: MyThemes.codeTheme,
              formattedCode: PigeonGeneratedCode_Client.importCode(),
              transition: _defaultTransition,
              notes: '可以注意到沒有 import 特別的套件，所以相依性很低',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Client',
              theme: MyThemes.codeTheme,
              formattedCode: PigeonGeneratedCode_Client.platformError(),
              transition: _defaultTransition,
              notes: 'just utils',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Client',
              theme: MyThemes.codeTheme,
              formattedCode: PigeonGeneratedCode_Client.deepEqualsCode(),
              transition: _defaultTransition,
              notes: 'just utils',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Client',
              theme: MyThemes.getCodeTheme(fontSize: 17),
              formattedCode: PigeonGeneratedCode_Client.deviceInfoCode(),
              transition: _defaultTransition,
              notes: '有清掉一些換行、改成 arrow return function、清掉 if 的 curly brace，不然塞不下簡報',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Client',
              theme: MyThemes.getCodeTheme(fontSize: 20),
              formattedCode: PigeonGeneratedCode_Client.codecCode(),
              transition: _defaultTransition,
              notes:
                  '以下很多部分需要配合 StandardMessageCodec 的 code 閱讀:\n\n'
                  ''
                  'writeValue 中的 `buffer.putUint8(4);` 和 `if (value is int)`\n'
                  '其中的 4 代表 Long (`private static final byte LONG = 4;`)\n'
                  '代表 pigeon 都會在傳給原生的時候把 int 當成 Long\n\n'
                  '',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Client',
              theme: MyThemes.getCodeTheme(fontSize: 24),
              formattedCode: PigeonGeneratedCode_Client.deviceApiCode(),
              transition: _defaultTransition,
              notes: [
                '🦄 Basic:\n\n'
                    '- 有刪除一些換行，不然塞不下簡報\n'
                    '- 為何可以 `(pigeonVar_replyList[0] as DeviceInfo?)!`，因為 BasicMessageChannel 有接收 pigeon 產生的 codec，已經將原始資料轉成 DeviceInfo',
                whyMessageChannelSuffixExistContent,
              ].join('\n\n========================\n\n'),
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Host',
              theme: MyThemes.codeTheme,
              formattedCode: PigeonGeneratedCode_Host.importCode(),
              transition: _defaultTransition,
              notes: '',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Host',
              theme: MyThemes.codeTheme,
              formattedCode: PigeonGeneratedCode_Host.errorCode(),
              transition: _defaultTransition,
              notes: '',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Host',
              theme: MyThemes.codeTheme,
              formattedCode: PigeonGeneratedCode_Host.codecCode(),
              transition: _defaultTransition,
              notes:
                  '🦄 class數量限制\n\n'
                  ''
                  '這邊可以看到 `129.toByte()`，事實上 pigeon 的 class 是有數量上限\n\n'
                  ''
                  'toByte 點進去可以看到註解寫數值範圍是 Byte.MIN_VALUE(-128) ~ Byte.MAX_VALUE(127)，扣掉保留的數量 0~127，所以 pigeon 最多只能產生 128 個 class\n\n'
                  ''
                  '雖然 standard 也是用 Standard API，但自己寫 standard 所以情況也會一樣，看要不要自己定義 byte 而已\n\n'
                  ''
                  '只是如果是寫 standard 的情況下，又要和 pigeon 一樣有 type safety 的話，就要自己維護這些 code (包含 client 和 host 各自的 read/write)\n\n'
                  ''
                  'StandardCodec 預設是支援 JSON 的資料類型',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Host',
              theme: MyThemes.getCodeTheme(fontSize: 17),
              formattedCode: PigeonGeneratedCode_Host.deviceInfoCode(),
              transition: _defaultTransition,
              notes: '',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Host',
              theme: MyThemes.getCodeTheme(fontSize: 20),
              formattedCode: PigeonGeneratedCode_Host.pigeonUtils(),
              transition: _defaultTransition,
              notes: '有減少一些換行、刪除一些 `{}`、省略一些不重要的，不然塞不下簡報',
            ),
            AnimatedCodeSlide(
              title: 'Pigeon Generated - Host',
              theme: MyThemes.getCodeTheme(fontSize: 20),
              formattedCode: PigeonGeneratedCode_Host.deviceApiCode(),
              transition: _defaultTransition,
              notes: '刪除一些註解',
            ),
            Slide(
              theme: SlideThemeData.dark(),
              builder: (BuildContext context) {
                var theme = SlideTheme.of(context)!;

                return ContentLayout(
                  title: DefaultTextStyle(
                    style: theme.textTheme.title,
                    textAlign: TextAlign.start,
                    child: GradientText(gradient: theme.textTheme.titleGradient, child: Text('錯誤處理')),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyThemes.buildSubtitle(context, Text('✨ Pigeon'), fontSize: 28),
                      MyThemes.buildContent(context, ErrorHandlingAtDiffMethod.atPigeon, fontSize: 20),
                      MyThemes.buildSubtitle(context, Text('✨ Standard Channel'), fontSize: 28),
                      MyThemes.buildContent(context, ErrorHandlingAtDiffMethod.standardPlatformChannel, fontSize: 20),
                    ],
                  ),
                );
              },
              notes:
                  '如果在 getDeviceInfo 裡面的實作直接改成 throw Exception，不用懷疑 Standard 情況下 `"getDeviceInfo" -> { throw }` 這種改法就是會變成 MissingPluginException，因為 MethodHandler.setHandler 就是沒處理好錯誤，'
                  '但其實不是沒有實作，而是實作的部分有問題，代表拋出的錯誤與實際不符合，根本不是 MissingPluginException；\n\n'
                  ''
                  '而 Pigeon 不但會把原生的實際錯誤留下來，還會讓你知道 StackTrace 在哪裡\n\n'
                  ''
                  '當然 Standard 也可以自己規範錯誤格式，但就要寫剛剛在 pigeon 看到的，在 Client 和 Host 都要判斷錯誤、邊解碼、加入 StackTrace\n\n'
                  ''
                  'pigeon 有加入 ui 和 host 的 StackTrace 也方便未來 debug，快速定位問題，省下很多時間\n\n',
              // 'Standard Channels
              //
              // 需要自行規範錯誤格式（通常用 PlatformException）。
              // 容易出現不同方法用不同錯誤結構，長期維護難。
              //
              // Pigeon
              //
              // 產生碼已統一錯誤封裝格式（code/message/details）。
              // 錯誤流通一致，不必自己規範。'
            ),
            BulletsSlide(
              title: 'Trending',
              bullets: [
                // 以下都是 2025/09/21 紀錄
                '1.17k likes', '140 / 160 pub points', '326k downloads',
                '過去一年有 35 個更新',
              ],
              image: const AssetImage('assets/pigeon_versions.png'),
              transition: _defaultTransition,
              notes:
                  '2025/09/21 publisher:flutter.dev 總共 88 個套件，326K Downloads 第 57 名，1.17K Likes 17 名\n\n'
                  ''
                  'Downloads 57 名看起來很糟，但是會用到這個套件只有牽涉到原生的時候才會用到，所以在只有原生才需要的情況下，還可以贏過很多套件\n\n'
                  ''
                  '如果是全部套件，下載量是 447 名，贏過: open_filex, intl_utils, syncfusion_flutter_charts, grpc, bot_toast, qr_code_scanner, oauth2, window_manager\n\n'
                  ''
                  '全部套件超過 100K 有 891 個\n\n'
                  ''
                  '140 Points:\n'
                  '- 少了 WASM (不需要)\n'
                  '- Pass static analysis: 7 issues，網頁上只顯示兩個 issues，都是在註解內\n'
                  '- Support up-to-date dependencies: 有10個套件沒跟上最新版，但是只有一個套件 analyzer 是 x 版本號差了一個\n\n'
                  ''
                  '==========================\n\n'
                  ''
                  '🦄 這麼多更新會不會導致不穩定或是升級困難?\n\n'
                  ''
                  '後續會提到',
            ),
            BulletsSlide(
              title: '型別安全 Type Safe',
              bullets: ['編譯期檢查', '避免開發者直接使用 as 強制轉型', '避免欄位缺漏', '支援 enum'],
              // Standard: 沒有編譯期檢查，容易因 typo 或欄位缺漏導致錯誤。
              notes:
                  'Standard:\n\n'
                  '寫了很多 as 強制轉型、很多字串(channel name, method name, json field name) 容易 typo\n\n'
                  ''
                  '複雜物件要自己寫編解碼\n\n'
                  ''
                  'pigeon:\n\n'
                  ''
                  '也可以支援 enum\n\n'
                  ''
                  '兩邊介面一致，編譯期就能發現錯誤。',
            ),
            BulletsSlide(
              theme: SlideThemeData.dark(),
              title: '開發速度',
              bullets: [
                '減少樣板程式碼，可以減少開發時間',
                // \assets\videos_no_version_control\compare_dev_speed_for_host_api_and_method_channel\2025-09-21 17-55-54_pigeon_host_api.mkv
                // \assets\videos_no_version_control\compare_dev_speed_for_host_api_and_method_channel\2025-09-21 19-20-43_method_channel.mkv
              ],
              notes:
                  '我有錄製影片來展示 pigeon 和 standard 的開發時間差異，以 MethodChannel 和 HostApi 作為範例，pigeon 為3~4分鐘，standard 為 2~3 分鐘，但是，這僅是最小實作，'
                  'standard 的範例中，並沒有使用更好的 error handling、最小量的傳輸、改善可讀性、class parsing/encode method，如果這些要素加上去，開發時間一定比 Pigeon 還長',
              //                   MyThemes.buildContent(
              //                     context,
              //                     // https://fluttercurious.com/demystifying-flutter-pigeon
              //                     Reduced Boilerplate: Pigeon eliminates the need for writing a lot of repetitive code for platform communication. It automates the process, saving you development time and effort.
              //
              //                     // https://www.genspark.ai/spark/a-comparison-between-flutter-pigeon-and-other-communication-plugins/9fb001a9-a9be-409d-8e51-8b1f3bd6d12c
              //                     // Development Time: Pigeon saves development time with its code generation feature, while MethodChannel increases development time due to the need for manual setup across all supported platforms.
              //
              //                     // https://www.dhiwise.com/post/how-flutter-pigeon-enhances-native-code-communication
              // //                     Text.rich(
              // //                       TextSpan(
              // //                         text: '''一篇不是很有名的文章
              // //
              // // Conclusion
              // //
              // // In conclusion, Flutter Pigeon provides a streamlined, type-safe approach to bridging communication between Flutter and native platforms. By automating boilerplate code generation for method channels, ''',
              // //                         children: [
              // //                           TextSpan(
              // //                             text: '''Pigeon saves developers time and reduces the potential for errors.''',
              // //                             style: TextStyle(color: MyColors.highlight),
              // //                           ),
              // //                           TextSpan(
              // //                             text:
              // //                                 ''' Whether you're dealing with simple data types or complex nested structures, Pigeon can handle the heavy lifting, allowing you to focus on building out the core features of your app.
              // //
              // // Embrace the power of Pigeon to enhance your Flutter app's native capabilities, and enjoy a development process that is more efficient, reliable, and enjoyable.''',
              // //                           ),
              // //                         ],
              // //                       ),
              // //                     ),
              //                     fontSize: 36,
              //                   ),
            ),
            BulletsSlide.rich(
              title: TextSpan(text: '可讀性'),
              bullets: [
                TextSpan(
                  text:
                      'Using this package eliminates the need to match strings between host and client for the names and data types of messages. '
                      'It supports nested classes, grouping messages into APIs, generation of asynchronous wrapper code, and sending messages in either direction. '
                      '',
                  children: [
                    TextSpan(
                      text: 'The generated code is readable ',
                      style: TextStyle(color: MyColors.highlight),
                    ),
                    TextSpan(
                      text: 'and guarantees there are no conflicts between multiple clients of different versions.',
                    ),
                  ],
                ),
              ],
              notes:
                  '來自官方文件的敘述 (backup: pigeon_is_readable_by_doc.png link: https://docs.flutter.dev/platform-integration/platform-channels#pigeon)',
            ),
            BulletsSlide(title: '', bullets: [], notes: ''),
            BulletsSlide(title: '', bullets: [], notes: ''),
            BulletsSlide(title: '', bullets: [], notes: ''),
            BulletsSlide(title: '', bullets: [], notes: ''),
          ],
        ),
        PositionedDirectional(
          start: 0,
          bottom: 0,
          child: MouseRegion(
            onEnter: (_) {
              _isHover.value = true;
            },
            onExit: (_) {
              _isHover.value = false;
            },
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ValueListenableBuilder(
                valueListenable: _isHover,
                builder: (context, isHover, __) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isHover ? 1 : 0.3,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(4)),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MenuPage()));
                      },
                      child: Icon(Icons.menu, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
