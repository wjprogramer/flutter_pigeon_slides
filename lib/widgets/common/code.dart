import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/theme/theme.dart';
import 'package:slick_slides/slick_slides.dart';

class Code extends StatelessWidget {
  const Code({super.key, this.language = 'dart', required this.code});

  final String language;

  final String code;

  @override
  Widget build(BuildContext context) {
    final highlighter = SlickSlides.highlighters[language]!;
    var highlightedCode = highlighter.highlight(code);
    return Text.rich(highlightedCode);
  }
}

/// 用於非 slide 頁面的程式碼顯示元件
/// 使用 ColoredCode 並包裝背景，字體大小適合一般頁面（非簡報）
class PageCodeBlock extends StatelessWidget {
  const PageCodeBlock({
    super.key,
    required this.code,
    this.language = 'dart',
    this.fontSize = 14.0,
    this.showLineNumbers = false,
    this.highlightedLines,
  });

  final String code;
  final String language;
  final double fontSize;
  final bool showLineNumbers;
  final List<int>? highlightedLines;

  @override
  Widget build(BuildContext context) {
    // 使用 SlideTheme 來提供 ColoredCode 所需的 theme
    final codeTheme = MyThemes.getCodeTheme(fontSize: fontSize);

    return SlideTheme(
      data: codeTheme,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: MyThemes.codeBackgroundColor,
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ColoredCode(
              code: code,
              language: language,
              highlightedLines: highlightedLines ?? const [],
              showLineNumbers: showLineNumbers,
            ),
          ),
        ),
      ),
    );
  }
}
