import 'package:flutter/material.dart';

ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: base.headline6.copyWith(
        fontFamily: 'Assistant-ExtraBold',
        fontSize: 28.0,
        color: Colors.black,
        letterSpacing: 1,
      ),
      headline4: base.headline4.copyWith(
       fontFamily: 'Assistant-SemiBold',
        fontSize: 18.0,
        color: Colors.black,
        letterSpacing: 1,
      ),
      headline3: base.headline3.copyWith(
        fontSize: 18.0,
        color: Colors.black,
        fontFamily: 'Assistant-ExtraBold',
      ),
      headline2: base.headline2.copyWith(
        fontSize:16.0,
        color:Colors.black,
        fontFamily: 'Assistant-SemiBold'
      ),
      headline1: base.headline1.copyWith(
          fontSize:40.0,
          color:Colors.black,
          letterSpacing: 4.0,
          fontFamily: 'Assistant',
          fontWeight: FontWeight.bold,

      ),
      bodyText1: base.bodyText1.copyWith(
          fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 1, color: Colors.black),
      bodyText2: base.bodyText2.copyWith(
          fontSize: 14,  color: Colors.black,
          fontFamily: 'Assistant-Light'
      ),
    );
  }

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme),
    primaryColor: Color(0xFF3277cd),
    backgroundColor: Color(0xFFc4daf5),
    accentColor: Color(0xFF5b9ae9),
    iconTheme: IconThemeData(color: Colors.grey[800], size: 20),
    appBarTheme: AppBarTheme(color: Color(0xFF5590c8)),
    buttonColor: Color(0xFF5590c8),
  );
}
