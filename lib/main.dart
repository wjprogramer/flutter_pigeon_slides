import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SlickSlides.initialize();

  runApp(const MyApp());
}

const _defaultTransition = SlickFadeTransition(
  color: Colors.black,
);

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SlideDeck(
      slides: [
        FullScreenImageSlide(
          image: const AssetImage('assets/logo-background.jpg'),
          title: 'Slick Slides',
          subtitle: 'Stunning presentations\nwith Flutter',
          alignment: const Alignment(0.6, 0.0),
          theme: const SlideThemeData.darkAlt(),
          transition: _defaultTransition,
        ),
        BulletsSlide(
          title: 'What is Slick Slides?',
          bulletByBullet: true,
          bullets: const [
            'Slick Slides was born out of the need to make nice looking '
                'slides for Serverpod at the FlutterCon conference.',
            'It comes with many built-in slide types, and is easy to '
                'extend with your own.',
            'Browse through the slides in this presentation to see '
                'what it can do.',
            'If you use Slick Slides for your presentation, please '
                'give some credit to Serverpod for the work we put into '
                'this package. Also, check out Serverpod if you haven\'t '
                'already, it\'s a great way to build your backend in '
                'Dart.',
          ],
          transition: _defaultTransition,
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
          image: const AssetImage(
            'assets/portrait.jpg',
          ),
          transition: _defaultTransition,
        ),
        Slide(
          builder: (context) {
            return const ContentLayout(
              content: Center(
                child: SizedBox(
                  width: 600,
                ),
              ),
            );
          },
          transition: const SlickFadeTransition(),
          onPrecache: (context) async {
          },
        ),
        BulletsSlide(
          theme: const SlideThemeData.light(),
          title: 'Themes',
          bullets: const [
            'Use the built in themes or create your own.',
            'This is the default light theme.',
          ],
          transition: _defaultTransition,
        ),
        AnimatedCodeSlide(
          formattedCode: [
            FormattedCode(
              code: _codeExampleA,
            ),
            FormattedCode(
              code: _codeExampleB,
              highlightedLines: [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
            ),
          ],
        ),
      ],
    );
  }
}