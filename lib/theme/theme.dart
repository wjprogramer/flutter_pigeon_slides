import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

class MyColors {
  MyColors._();

  static final highlight = Colors.orange;
  static final highlight2 = Colors.blue;
  static final highlight3 = Colors.green;
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

  static SlideThemeData getCodeTheme({
    double fontSize = 24.0,
  }) => SlideThemeData.dark(
    textTheme: SlideTextThemeData.dark(
      code: TextStyle(
        fontFamily: 'JetBrainsMono',
        color: Color(0xffabdafc),
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        fontVariations: [FontVariation('wght', 400)],
      ),
    ),
  );

  static Widget buildSubtitle(BuildContext context, Widget text, {
    double? fontSize,
  }) {
    var theme = SlideTheme.of(context)!;

    return DefaultTextStyle(
      style: theme.textTheme.subtitle.copyWith(
        fontSize: fontSize,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: text,
      ),
    );
  }

  static Widget buildContent(BuildContext context, Widget text, {
    double? fontSize,
  }) {
    var theme = SlideTheme.of(context)!;

    return DefaultTextStyle(
      style: theme.textTheme.subtitle.copyWith(
        fontSize: fontSize,
      ),
      child: text,
    );
  }
}
