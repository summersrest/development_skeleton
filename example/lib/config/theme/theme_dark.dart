import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData blackThemeLight = ThemeData(
  brightness: Brightness.light,
  useMaterial3: false,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF000000),
    selectionColor: Color(0xFF0A0A0A),
    selectionHandleColor: Color(0xFF050505),
  ),
  primaryColor: const Color(0xFF050505),
  appBarTheme: const AppBarTheme(color: Color(0xFF050505)),
  extensions: const <ThemeExtension<dynamic>>[
    AppColors(
      primary: Color(0xFF050505),
      backgroundColor: Color(0xFFF4F4F4),
      accent: Color(0xFFE83A3A),
      textLight: Color(0xFFBCBCBC),
      textDart: Color(0xFF212529),
      textColor: Color(0xFF22293A),
      lineColor: Color(0xFFBDBDBD),
    )
  ],
);

final ThemeData blackThemeDark = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: false,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF000000),
    selectionColor: Color(0xFF0A0A0A),
    selectionHandleColor: Color(0xFF050505),
  ),
  primaryColor: const Color(0xFF050505),
  appBarTheme: const AppBarTheme(color: Color(0xFF050505)),
  extensions: const <ThemeExtension<dynamic>>[
    AppColors(
      primary: Color(0xFFE7A5A5),
      backgroundColor: Color(0xFFF4F4F4),
      accent: Color(0xFFE83A3A),
      textLight: Color(0xFFBCBCBC),
      textDart: Color(0xFF212529),
      textColor: Color(0xFF22293A),
      lineColor: Color(0xFFBDBDBD),
    )
  ],
);
