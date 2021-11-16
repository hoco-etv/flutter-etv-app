import 'package:flutter/material.dart';

const borderRadius = 14.0;
const innerBorderRadius = 6.0;
const pagePadding = borderRadius;

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
const greenPrimary = 0xFF9BC53D;
const bluePrimary = 0xFF5BC0EB;
const yellowPrimary = 0xFFFDE74C;
const orangePrimary = 0xFFFA7921;

const barelyBlack = Color(0xFF252730);
const barelyWhite = Color(0xFFF2F5F8);
const titleGrey = Color(0xFF404245);
const disabledGrey = Color(0xFFA0A2A5);
