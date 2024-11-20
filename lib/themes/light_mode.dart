import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: const Color.fromARGB(255, 250, 237, 237),
    primary: const Color.fromARGB(255, 225, 225, 225),
    secondary: const Color.fromARGB(255, 255, 255, 255),
    tertiary: const Color.fromARGB(255, 120, 119, 119),
    inversePrimary: Colors.grey.shade300,
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 233, 233, 233),
);
