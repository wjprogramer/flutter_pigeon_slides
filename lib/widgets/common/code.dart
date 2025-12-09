import 'package:flutter/material.dart';
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
