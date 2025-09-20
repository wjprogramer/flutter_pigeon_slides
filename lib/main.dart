import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pigeon_slides/theme/theme.dart';
import 'package:slick_slides/slick_slides.dart';

import 'code/code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SlickSlides.initialize();

  runApp(const MyApp());
}

const _defaultTransition = SlickFadeTransition(color: Colors.black);

const _codeExampleA = '''class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
  }
}''';

const _codeExampleB = '''class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideDeck(
      slides: [
        Slide(
          builder: (context) {
            return const TitleSlide(
              title: Text('Slick Slides'),
              subtitle: Text('Stunning presentations in Flutter'),
            );
          },
        ),
      ],
    );
  }
}''';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slick Slides Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideDeck(
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
          bullets: ['非同步傳遞訊息的機制，\n保持UI可反應', '可雙向溝通', '允許極少樣板程式碼開發'],
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
          name: '1. Client call Host',
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
          notes: '@ConfigurePigeon 裡面也是可以抽出去',
        ),
        BulletsSlide(
          title: '使用 Pigeon - Generate',
          bullets: [
            'dart run pigeons --input xxxx.dart',
            'for f in pigeons/*.dart; do dart run pigeons --input \$f; done',
            'make pigeon # Makefile',
          ],
          transition: _defaultTransition,
        ),
        AnimatedCodeSlide(
          title: '使用 Pigeon - Client',
          theme: MyThemes.codeTheme,
          formattedCode: PigeonBasicCode_Client.formattedCode(),
          transition: _defaultTransition,
          notes: '',
        ),
        BulletsSlide(
          title: 'Bullets with images',
          image: const AssetImage('assets/serverpod-avatars.webp'),
          bullets: [
            'Add images to you presentation with a single line of code.',
            'Bullet point slides can have images too.',
          ],
          transition: _defaultTransition,
        ),
        PersonSlide(
          title: 'Rockstar Flutter Developer',
          name: 'Philippa Flutterista',
          image: const AssetImage('assets/portrait.jpg'),
          transition: _defaultTransition,
        ),
        BulletsSlide(
          theme: const SlideThemeData.light(),
          title: 'Themes',
          bullets: const ['Use the built in themes or create your own.', 'This is the default light theme.'],
          transition: _defaultTransition,
        ),
      ],
    );
  }
}
