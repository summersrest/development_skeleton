import 'package:flutter/material.dart';

import 'app_colors.dart';

///# 默认主题
///
///## 说明：默认主题-亮色
final ThemeData greenThemeLight = ThemeData(
  brightness: Brightness.light,
  useMaterial3: false,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF12B886),
    selectionColor: Color(0xFF12B886),
    selectionHandleColor: Color(0xFF12B886),
  ),
  primaryColor: const Color(0xFF12B886),
  appBarTheme: const AppBarTheme(color: Color(0xFF12B886)),
  extensions: const <ThemeExtension<dynamic>>[
    AppColors(
      primary: Color(0xFF12B886),
      backgroundColor: Color(0xFFF4F4F4),
      accent: Color(0xFFE83A3A),
      textLight: Color(0xFF969696),
      textDart: Color(0xFF212529),
      textColor: Color(0xFF22293A),
      lineColor: Color(0xFFEFEFEF),
    ),
  ],
);

///# 默认主题
///
///## 说明：默认主题-暗色
final ThemeData greenThemeDark = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: false,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF12B886),
    selectionColor: Color(0xFF12B886),
    selectionHandleColor: Color(0xFF12B886),
  ),
  primaryColor: const Color(0xFF12B886),
  appBarTheme: const AppBarTheme(color: Color(0xFF12B886)),
  extensions: const <ThemeExtension<dynamic>>[
    AppColors(
      primary: Color(0xFF5F6E69),
      backgroundColor: Color(0xFFF4F4F4),
      accent: Color(0xFFE83A3A),
      textLight: Color(0xFF969696),
      textDart: Color(0xFF212529),
      textColor: Color(0xFF22293A),
      lineColor: Color(0xFFEFEFEF),
    ),
  ],
);
