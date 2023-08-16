/// This file contains the theme data for the app.
library barbershop_theme;

import 'package:flutter/material.dart';

import 'constants.dart';

const _defaultInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: ColorConstants.grey),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

final themeData = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: ColorConstants.grey),
    filled: true,
    fillColor: Colors.white,
    errorBorder: _defaultInputBorder.copyWith(
      borderSide: const BorderSide(color: ColorConstants.red),
    ),
    focusedBorder: _defaultInputBorder,
    border: _defaultInputBorder,
  ),
  useMaterial3: true,
  fontFamily: FontConstants.fontFamily,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorConstants.brown,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  ),
);
