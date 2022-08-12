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

const linkStyle = TextStyle(
  color: etvRed,
  decoration: TextDecoration.underline,
);

// https://coolors.co/b41f21-5bc0eb-fde74c-9bc53d-fa7921
const greenPrimary = 0xFF8BD53D;
const bluePrimary = 0xFF5BC0EB;
const yellowPrimary = 0xFFFDE74C;
const orangePrimary = 0xFFFA7921;

const barelyBlack = Color(0xFF252730);
const almostWhite = Color(0xFFFCFDFE);
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
  final colorScheme = brightness == Brightness.light ? _lightColorScheme : _darkColorScheme;
  final baseTheme = ThemeData.from(
    colorScheme: colorScheme,

    textTheme: TextTheme(
      bodyText1: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
      bodyText2: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),

      headline1: TextStyle(
        fontSize: 36,
        fontFamily: 'RobotoSlab',
        fontWeight: FontWeight.w300,
        height: 1.5,
        color: colorScheme.onBackground,
      ),
      headline2: TextStyle(
        fontSize: 32,
        fontFamily: 'RobotoSlab',
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: colorScheme.onBackground,
      ),
      headline3: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: colorScheme.onBackground,
      ),

      headline4: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: colorScheme.onSurface.withOpacity(0.8),
      ),
      headline5: const TextStyle(
        fontSize: 17,
        fontFamily: 'RobotoSlab',
        height: 1.5,
      ),
      headline6: const TextStyle(
        fontSize: 15,
        fontFamily: 'RobotoSlab',
        height: 1.5,
      ),

      subtitle1: TextStyle(
        fontSize: 15,
        fontFamily: 'RobotoSlab',
        height: 1.5,
        color: colorScheme.onSurface.withOpacity(0.6),
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: colorScheme.onSurface.withOpacity(0.6),
      ),

      button: const TextStyle(
        color: almostWhite,
      ),
    ),
  );

  return baseTheme.copyWith(
    cardTheme: CardTheme(
      shape: borderShape,
    ),

    dividerColor: Colors.transparent,

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
