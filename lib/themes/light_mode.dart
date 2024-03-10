import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightMode = ThemeData(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.grey.shade600,
    ),
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade200,
      primary: Colors.grey.shade600,
      secondary: Colors.grey.shade300,
      tertiary: Colors.white,
      inversePrimary: Colors.grey.shade300,
    ));
