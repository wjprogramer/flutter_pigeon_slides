import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

class MyColors {
  MyColors._();

  static final highlight = Colors.orange;
}

class MyThemes {
  MyThemes._();

  static final codeTheme = SlideThemeData.dark(
    textTheme: const SlideTextThemeData.dark(
      code: TextStyle(
        fontFamily: 'JetBrainsMono',
        color: Color(0xffabdafc),
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        fontVariations: [FontVariation('wght', 400)],
      ),
    ),
  );
}
