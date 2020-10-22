import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xff0d86ca);
  static const Color accentColor = Color(0xffef4834);
  static const Color inactiveGreyColor = Color(0xff6e6e6e);
  static const Color successColor = Color(0xff78e777);

  static final ThemeData lightTheme = ThemeData(
    accentColor: accentColor,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
    dividerColor: Colors.transparent,
  );

  // static final ThemeData darkTheme = ThemeData(
  //   scaffoldBackgroundColor: Colors.black,
  //   brightness: Brightness.dark,
  //   textTheme: darkTextTheme,
  // );

  static final TextTheme lightTextTheme = TextTheme(
    headline1: _titleLight,
    headline2: _subTitleLight,
    // button: _buttonLight,
    bodyText1: _bodyText1,
    bodyText2: _bodyText2,
  );

  // static final TextTheme darkTextTheme = TextTheme(
  //   headline1: _titleDark,
  //   headline2: _subTitleDark,
  //   button: _buttonDark,
  //   bodyText1: _greetingDark,
  //   bodyText2: _searchDark,
  // );

  static final TextStyle _titleLight = GoogleFonts.adamina().copyWith(
    color: Colors.black,
    fontSize: 5 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle _subTitleLight = GoogleFonts.roboto().copyWith(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontSize: 3 * SizeConfig.textMultiplier,
  );
  static final TextStyle _bodyText1 = GoogleFonts.roboto().copyWith(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontSize: 2.2 * SizeConfig.textMultiplier,
  );
  static final TextStyle _bodyText2 = GoogleFonts.roboto().copyWith(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontSize: 1.8 * SizeConfig.textMultiplier,
  );
  // static final TextStyle _buttonLight = TextStyle(
  //   color: Colors.black,
  //   fontSize: 2.5 * SizeConfig.textMultiplier,
  // );

  // static final TextStyle _selectedTabLight = TextStyle(
  //   color: Colors.black,
  //   fontWeight: FontWeight.bold,
  //   fontSize: 2 * SizeConfig.textMultiplier,
  // );

  // static final TextStyle _unSelectedTabLight = TextStyle(
  //   color: Colors.grey,
  //   fontSize: 2 * SizeConfig.textMultiplier,
  // );

  // static final TextStyle _titleDark = _titleLight.copyWith(color: Colors.white);

  // static final TextStyle _subTitleDark =
  //     _subTitleLight.copyWith(color: Colors.white70);

  // static final TextStyle _buttonDark =
  //     _buttonLight.copyWith(color: Colors.black);

  // static final TextStyle _greetingDark =
  //     _greetingLight.copyWith(color: Colors.black);

  // static final TextStyle _searchDark =
  //     _searchDark.copyWith(color: Colors.black);

  // static final TextStyle _selectedTabDark =
  //     _selectedTabDark.copyWith(color: Colors.white);

  // static final TextStyle _unSelectedTabDark =
  //     _selectedTabDark.copyWith(color: Colors.white70);
}
