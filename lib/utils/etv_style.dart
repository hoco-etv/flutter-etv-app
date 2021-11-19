import 'package:flutter/material.dart';

const borderRadius = 20.0;
const innerBorderRadius = 8.0;
final borderShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius));
final innerBorderShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(innerBorderRadius));

const outerPaddingSize = borderRadius;
const innerPaddingSize = borderRadius - innerBorderRadius;
const outerPadding = EdgeInsets.all(outerPaddingSize);
const innerPadding = EdgeInsets.all(innerPaddingSize);

const etvRedPrimary = 0xFFB41F21;

const etvRed = MaterialColor(
  etvRedPrimary,
  <int, Color>{
    50: Color(0xFFE46264),
    100: Color(0xFFE15153),
    200: Color(0xFFDE3F42),
    300: Color(0xFFDC2E31),
    400: Color(0xFFD12326),
    500: Color(etvRedPrimary),
    600: Color(0xFF9D1B1D),
    700: Color(0xFF8C181A),
    800: Color(0xFF7A1516),
    900: Color(0xFF691213),
  }
);

// https://coolors.co/b41f21-5bc0eb-fde74c-9bc53d-fa7921
const greenPrimary = 0xFF8BD53D;
const bluePrimary = 0xFF5BC0EB;
const yellowPrimary = 0xFFFDE74C;
const orangePrimary = 0xFFFA7921;

const barelyBlack = Color(0xFF252730);
const almostWhite = Color(0xFFFCFDFE);
const titleGrey = Color(0xFF404245);
const disabledGrey = Color(0xFFA0A2A5);

final _lightColorScheme = ColorScheme.light(
  primary: etvRed,

  background: Colors.grey.shade100,
  surface: almostWhite,
);

final _darkColorScheme = ColorScheme.dark(
  primary: etvRed,

  surface: Colors.grey.shade900,
  onPrimary: almostWhite,
);

ThemeData getTheme(Brightness brightness)
{
  final baseTheme = ThemeData.from(
    colorScheme: brightness == Brightness.light ? _lightColorScheme : _darkColorScheme,
  );

  return baseTheme.copyWith(
    cardTheme: CardTheme(
      shape: borderShape,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
          horizontal: outerPaddingSize,
          vertical: outerPaddingSize/2,
        )),
        shape: MaterialStateProperty.all(innerBorderShape),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(innerBorderRadius)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: outerPaddingSize,
        vertical: outerPaddingSize/2
      ),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    }),
  );
}
