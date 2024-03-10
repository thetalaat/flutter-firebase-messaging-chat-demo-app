import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade600,
      foregroundColor: Colors.grey.shade200,
    ),
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      primary: Colors.grey.shade600,
      secondary: Colors.grey.shade200,
      tertiary: Colors.white,
      inversePrimary: Colors.grey.shade300,
    ));
