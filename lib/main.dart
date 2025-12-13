import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/app_scale.dart';
import 'package:flutter_pigeon_slides/pages/menu/menu_page.dart';
import 'package:flutter_pigeon_slides/theme/theme.dart';
import 'package:flutter_pigeon_slides/utils/error_handling.dart';
import 'package:flutter_pigeon_slides/utils/why_message_channel_suffix_exist.dart';
import 'package:slick_slides/slick_slides.dart';

import 'code/code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SlickSlides 同時會初始化 Highlighter (pkg: syntax_highlight)
  await SlickSlides.initialize(
    languages: ['dart', 'yaml', 'serverpod_protocol', 'kotlin', 'swift'],
  );

  runApp(const MyApp());
}

const _defaultTransition = SlickFadeTransition(color: Colors.black);

/// 產生四個方向的文字陰影效果（右下、左上、右上、左下）
///
/// [offset] 陰影的偏移距離
/// [blurRadius] 陰影的模糊半徑
/// [opacity] 陰影的透明度（0.0-1.0）
List<Shadow> createTextShadows({
  double offset = 2.0,
  double blurRadius = 4.0,
  double opacity = 0.8,
}) {
  final color = Color.fromRGBO(0, 0, 0, opacity);
  return [
    Shadow(
      offset: Offset(offset, offset), // 右下
      blurRadius: blurRadius,
      color: color,
    ),
    Shadow(
      offset: Offset(-offset, -offset), // 左上
      blurRadius: blurRadius,
      color: color,
    ),
    Shadow(
      offset: Offset(offset, -offset), // 右上
      blurRadius: blurRadius,
      color: color,
    ),
    Shadow(
      offset: Offset(-offset, offset), // 左下
      blurRadius: blurRadius,
      color: color,
    ),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pigeon 介紹',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return ValueListenableBuilder<double>(
          valueListenable: appScale,
          builder: (context, scale, _) {
            // 簡報頁(MyHomePage)不縮放，其他頁套用全域縮放。
            if (child is MyHomePage) return child;
            final media = MediaQuery.of(context);
            final scaled = scale.clamp(0.8, 1.8);
            return MediaQuery(
              data: media.copyWith(textScaler: TextScaler.linear(scaled)),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
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
  final _deckController = SlideDeckController(controlsAlwaysVisible: true);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SlideDeck(
        theme: MyThemes.lightTheme,
        controller: _deckController,
        showPageNumber: true,
        controlActions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(4)),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const MenuPage()));
            },
            child: const Icon(Icons.menu, color: Colors.white),
          ),
          const SizedBox(width: 8),
          SlideOverviewButton(controller: _deckController),
        ],
        slides: [
          Slide(
            theme: MyThemes.lightTheme,
            transition: _defaultTransition,
            builder: (context) {
              final theme = SlideTheme.of(context)!;
              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: Image(
                      image: const AssetImage(
                        'assets/pigeon_cover_by_ai_improve_resolution.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: theme.borderPadding,
                    child: Align(
                      alignment: const Alignment(0.0, 1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DefaultTextStyle(
                            style: theme.textTheme.title.copyWith(
                              shadows: createTextShadows(
                                blurRadius: 40,
                                offset: 5,
                                opacity: 0.2,
                              ),
                            ),
                            textAlign: TextAlign.center,
                            child: const Text('Pigeon 介紹'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: DefaultTextStyle(
                              style: theme.textTheme.subtitle.copyWith(
                                color: Colors.white,
                                shadows: createTextShadows(
                                  blurRadius: 40,
                                  offset: 5,
                                  opacity: 0.2,
                                ),
                              ),
                              textAlign: TextAlign.center,
                              child: GradientText(
                                gradient: theme.textTheme.subtitleGradient,
                                child: const Text('型別安全、維護性高與原生溝通'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            onPrecache: (context) async {
              await precacheImage(
                const AssetImage(
                  'assets/pigeon_cover_by_ai_improve_resolution.jpg',
                ),
                context,
              );
            },
          ),
          BulletsSlide.rich(
            theme: MyThemes.lightTheme,
            title: TextSpan(text: '與原生溝通的方式'),
            bulletByBullet: true,
            bullets: [
              TextSpan(
                text: '1. Standard Platform Channels API\n',
                children: [
                  TextSpan(
                    text:
                        '       (MethodChannel / EventChannel / BasicMessageChannel)',
                    style: TextStyle(fontSize: 25, color: Colors.grey.shade600),
                  ),
                ],
              ),
              TextSpan(
                text: '2. Pigeon package\n',
                children: [
                  TextSpan(
                    text:
                        '       (HostApi / EventChannelApi / FlutterApi / ProxyApi)',
                    style: TextStyle(fontSize: 25, color: Colors.grey.shade600),
                  ),
                ],
              ),
              TextSpan(
                text: '3. dart:ffi 直接呼叫原生函式庫\n',
                children: [
                  TextSpan(
                    text: '       適用 C/C++ 或預先編譯的動態函式庫，走位元階層而非 Channels',
                    style: TextStyle(fontSize: 25, color: Colors.grey.shade600),
                  ),
                ],
              ),
              TextSpan(
                text: '4. JS interoperability or the package:web library',
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
            theme: MyThemes.lightTheme,
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
          CodeSlideWithBackground(
            title: '使用 Platform Channels - Client',
            theme: MyThemes.codeTheme,
            formattedCode:
                PlatformChannelMethodChannelCode_Client.formattedCode(),
            notes: 'Create the Flutter platform client',
            transition: _defaultTransition,
          ),
          CodeSlideWithBackground(
            title: '使用 Platform Channels - Host',
            language: 'kotlin',
            theme: MyThemes.codeTheme,
            formattedCode:
                PlatformChannelMethodChannelCode_Host.formattedCode(),
            // language: 'java', // 不支援
            notes: 'Create the Flutter platform Host',
            transition: _defaultTransition,
          ),
          CodeSlideWithBackground(
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
          CodeSlideWithBackground(
            title: '使用 Pigeon - Client',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonBasicCode_Client.formattedCode(),
            transition: _defaultTransition,
            notes: '',
          ),
          CodeSlideWithBackground(
            title: '使用 Pigeon - Host',
            language: 'kotlin',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonBasicCode_Host.formattedCode(),
            transition: _defaultTransition,
            notes: '',
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Client',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Client.importCode(),
            transition: _defaultTransition,
            notes: '可以注意到沒有 import 特別的套件，所以相依性很低',
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Client',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Client.platformError(),
            transition: _defaultTransition,
            notes: 'just utils',
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Client',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Client.deepEqualsCode(),
            transition: _defaultTransition,
            notes: 'just utils',
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Client',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Client.deviceInfoCode(),
            transition: _defaultTransition,
            notes:
                '有清掉一些換行、改成 arrow return function、清掉 if 的 curly brace，不然塞不下簡報',
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Client',
            theme: MyThemes.codeTheme,
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
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Client',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Client.deviceApiCode(),
            transition: _defaultTransition,
            notes: [
              '🦄 Basic:\n\n'
                  '- 有刪除一些換行，不然塞不下簡報\n'
                  '- 為何可以 `(pigeonVar_replyList[0] as DeviceInfo?)!`，因為 BasicMessageChannel 有接收 pigeon 產生的 codec，已經將原始資料轉成 DeviceInfo',
              whyMessageChannelSuffixExistContent,
            ].join('\n\n========================\n\n'),
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Host',
            language: 'kotlin',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Host.importCode(),
            transition: _defaultTransition,
            notes: '',
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Host',
            language: 'kotlin',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Host.errorCode(),
            transition: _defaultTransition,
            notes: '',
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Host',
            language: 'kotlin',
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
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Host',
            language: 'kotlin',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Host.deviceInfoCode(),
            transition: _defaultTransition,
            notes: '',
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Host',
            language: 'kotlin',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Host.pigeonUtils(),
            transition: _defaultTransition,
            notes: '有減少一些換行、刪除一些 `{}`、省略一些不重要的，不然塞不下簡報',
          ),
          CodeSlideWithBackground(
            title: 'Pigeon Generated - Host',
            language: 'kotlin',
            theme: MyThemes.codeTheme,
            formattedCode: PigeonGeneratedCode_Host.deviceApiCode(),
            transition: _defaultTransition,
            notes: '刪除一些註解',
          ),
          Slide(
            theme: MyThemes.lightTheme,
            builder: (BuildContext context) {
              var theme = SlideTheme.of(context)!;

              return ContentLayout(
                title: DefaultTextStyle(
                  style: theme.textTheme.title,
                  textAlign: TextAlign.start,
                  child: GradientText(
                    gradient: theme.textTheme.titleGradient,
                    child: Text('錯誤處理'),
                  ),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyThemes.buildSubtitle(
                      context,
                      Text('✨ Pigeon'),
                      fontSize: 28,
                    ),
                    MyThemes.buildContent(
                      context,
                      ErrorHandlingAtDiffMethod.atPigeon,
                      fontSize: 20,
                    ),
                    MyThemes.buildSubtitle(
                      context,
                      Text('✨ Standard Channel'),
                      fontSize: 28,
                    ),
                    MyThemes.buildContent(
                      context,
                      ErrorHandlingAtDiffMethod.standardPlatformChannel,
                      fontSize: 20,
                    ),
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
            theme: MyThemes.lightTheme,
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
          BulletsSlide(
            theme: MyThemes.lightTheme,
            title: '何時使用 Pigeon vs Standard Channels',
            bullets: [
              '✨ 建議使用 Pigeon：',
              '   • 需要型別安全的複雜資料結構',
              '   • 多平台需要一致介面',
              '   • 團隊協作，需要明確契約',
              '   • API 會持續演進',
              '',
              '⚡ 可考慮 Standard Channels：',
              '   • 極簡單的一次性需求',
              '   • PoC 快速驗證',
              '   • 已有穩定的手寫實作',
            ],
            transition: _defaultTransition,
            notes: '這是一個建議，不是絕對規則。重點是根據團隊情況和專案需求來選擇。',
          ),
          BulletsSlide(
            theme: MyThemes.lightTheme,
            title: '總結',
            bullets: [
              '✅ 型別安全：編譯期檢查，減少 runtime 錯誤',
              '✅ 開發效率：減少樣板程式碼，提升開發速度',
              '✅ 錯誤處理：統一的錯誤封裝格式',
              '✅ 可維護性：介面即契約，兩邊保持一致',
              '✅ 可讀性：介面定義清晰，生成碼完整',
              '',
              '💡 建議：新專案或新 API 優先考慮 Pigeon',
            ],
            transition: _defaultTransition,
            notes: '總結 Pigeon 的核心優勢，幫助聽眾記住重點。',
          ),
        ],
      ),
    );
  }
}
