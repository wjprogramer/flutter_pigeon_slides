import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

/// 自定義的 Code Slide，將代碼內容包裝在黑色背景中
class CodeSlideWithBackground extends Slide {
  CodeSlideWithBackground({
    String? title,
    String? subtitle,
    required List<FormattedCode> formattedCode,
    String language = 'dart',
    String? notes,
    SlickTransition? transition,
    SlideThemeData? theme,
    Duration? autoplayDuration,
    Source? audioSource,
  }) : super.withSubSlides(
          builder: (context, index) {
            var highlightedLines = formattedCode[index].highlightedLines;
            var code = formattedCode[index].code;

            Widget content;
            if (index == 0) {
              content = ColoredCode(
                code: code,
                language: language,
                highlightedLines: highlightedLines,
              );
            } else {
              content = ColoredCode(
                animateFromCode: formattedCode[index - 1].code,
                code: code,
                language: language,
                highlightedLines: highlightedLines,
                animateHighlightedLines: true,
              );
            }

            // 將代碼內容包裝在黑色背景的 Container 中
            final codeWithBackground = Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
              color: MyThemes.codeBackgroundColor,
              borderRadius: BorderRadius.circular(16.0),

              ),
              child: content,
            );

            return ContentLayout(
              title: title == null ? null : Text(title),
              subtitle: subtitle == null ? null : Text(subtitle),
              content: codeWithBackground,
            );
          },
          subSlideCount: formattedCode.length,
          notes: notes,
          transition: transition,
          theme: theme,
          autoplayDuration: autoplayDuration,
          audioSource: audioSource,
        );
}

class MyColors {
  MyColors._();

  static final highlight = Colors.orange;
  static final highlight2 = Colors.green;
  static final highlight3 = Colors.blue;
}

class MyThemes {
  MyThemes._();

  static const titleGradient = LinearGradient(
    colors: [Color(0xFF477E67), Color(0xFF203B72)],
    // colors: [Color(0xFF203B72), Color(0xFF203B72)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const textTheme = SlideTextThemeData.light(
    titleGradient: titleGradient,
  );

  // 共用的 light theme
  static const lightTheme = SlideThemeData.light(textTheme: textTheme);

  // 代碼區塊背景色
  static const codeBackgroundColor = Color(0xFF181818);

  static final codeTheme = SlideThemeData.light(
    textTheme: const SlideTextThemeData.light(
      titleGradient: titleGradient,
      code: TextStyle(
        fontFamily: 'JetBrainsMono',
        color: Color(0xffabdafc), // 淺藍色，適合深色背景
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        fontVariations: [FontVariation('wght', 400)],
      ),
    ),
  );

  static SlideThemeData getCodeTheme({double fontSize = 24.0}) =>
      SlideThemeData.light(
        textTheme: SlideTextThemeData.light(
          code: TextStyle(
            fontFamily: 'JetBrainsMono',
            color: const Color(0xffabdafc), // 淺藍色，適合深色背景
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            fontVariations: [FontVariation('wght', 400)],
          ),
        ),
      );

  static Widget buildSubtitle(
    BuildContext context,
    Widget text, {
    double? fontSize,
  }) {
    var theme = SlideTheme.of(context)!;

    return DefaultTextStyle(
      style: theme.textTheme.subtitle.copyWith(fontSize: fontSize),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: text,
      ),
    );
  }

  static Widget buildContent(
    BuildContext context,
    Widget text, {
    double? fontSize,
  }) {
    var theme = SlideTheme.of(context)!;

    return DefaultTextStyle(
      style: theme.textTheme.subtitle.copyWith(fontSize: fontSize),
      child: text,
    );
  }

  /// 包裝代碼內容，添加黑色背景
  static Widget wrapCodeWithBackground(Widget codeContent) {
    return Container(
      color: codeBackgroundColor,
      padding: const EdgeInsets.all(16.0),
      child: codeContent,
    );
  }
}
