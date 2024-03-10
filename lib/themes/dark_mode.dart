import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkMode = ThemeData(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.grey.shade600,
    ),
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.grey.shade500,
      secondary: Colors.grey.shade700,
      tertiary: Colors.grey.shade800,
      inversePrimary: Colors.grey.shade300,
    ));
