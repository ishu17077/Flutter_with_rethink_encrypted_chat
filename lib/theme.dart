// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/colors.dart';
import 'package:google_fonts/google_fonts.dart';

const appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  backgroundColor: Colors.white,
);

ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
      primaryColor: kPrimary,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: appBarTheme,
      iconTheme: const IconThemeData(color: kIconLight),
      textTheme:
          GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme).apply(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
      primaryColor: kPrimary,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: appBarTheme.copyWith(backgroundColor: kAppBarDark),
      iconTheme: const IconThemeData(color: Colors.black),
      textTheme:
          GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme).apply(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

bool isLightTheme(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.light;
  //? platform brightness is essencially checking for dark mode or light mode
}
