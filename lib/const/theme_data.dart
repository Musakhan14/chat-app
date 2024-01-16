import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.blue,
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: const TextStyle(
        color: Colors.blue,
      ),
      foregroundColor: Colors.blue,
      side: const BorderSide(
        color: Colors.blue,
        width: 1.7,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    errorBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    suffixIconColor: Colors.grey,
    prefixIconColor: Colors.grey,
    disabledBorder: outlineInputBorder,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      textStyle: const TextStyle(
        fontSize: 18,
      ),
      disabledBackgroundColor: Colors.grey,
    ),
  ),
  primarySwatch: Colors.blue,
  canvasColor: Colors.blue,
  appBarTheme: const AppBarTheme(
    toolbarTextStyle: TextStyle(
      color: Colors.white,
    ),
    backgroundColor: Colors.blue,
    elevation: 0.0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
);
OutlineInputBorder outlineInputBorder =
    const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));
