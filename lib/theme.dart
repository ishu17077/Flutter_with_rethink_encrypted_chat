// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_with_rethink_encrypted_app/colors.dart';
import 'package:google_fonts/google_fonts.dart';

const appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  backgroundColor: Colors.white,
);

final tabBarTheme = TabBarTheme(
  indicatorSize: TabBarIndicatorSize.label,
  unselectedLabelColor: Colors.black54,
  indicator: BoxDecoration(
    borderRadius: BorderRadius.circular(50.0),
    color: kPrimary,
  ),
);
final dividerTheme =const DividerThemeData().copyWith(thickness: 1.1, indent: 75);

ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
      primaryColor: kPrimary,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: appBarTheme,
      tabBarTheme: tabBarTheme,
      dividerTheme: dividerTheme.copyWith(color: kIconLight),
      iconTheme: const IconThemeData(color: kIconLight),
      textTheme:
          GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme).apply(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
      primaryColor: kPrimary,
      scaffoldBackgroundColor: Colors.black,
      tabBarTheme: tabBarTheme.copyWith(unselectedLabelColor: Colors.white70),
      appBarTheme: appBarTheme.copyWith(backgroundColor: kAppBarDark),
      iconTheme: const IconThemeData(color: Colors.black),
      dividerTheme: dividerTheme.copyWith(color: kBubbleDark),
      textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme)
          .apply(displayColor: Colors.white),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

bool isLightTheme(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.light;
  //? platform brightness is essencially checking for dark mode or light mode
}
