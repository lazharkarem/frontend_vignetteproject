import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

String baseURL = "http://localhost:3000/api/";
String baseUploadsURL = "http://localhost:3000/uploads/"; //ressources route

DateFormat datetimeFormat = DateFormat("dd/MM/yyyy HH:mm");
DateFormat dateFormat = DateFormat("dd/MM/yyyy");
DateFormat timeFormat = DateFormat("HH:mm");

DateTime defaultDateTime = DateTime.parse("1964-08-08 20:18:04Z");

// Original Palette
class Palette {
  static const Color iconColor = Color(0xffaabbcc);
  static const Color primaryColor = Color(0xff0678ea);
  static const Color secondaryColor = Color(0xff679de5);
  static const Color thirdColor = Color(0xff679de5);
  static const Color fourthColor = Color(0xff8fb9f1);

  static const Color textColor = Color(0xffffffff);
  static const Color textColor1 = Color(0XFFA7BCC7);
  static const Color textColor2 = Color(0XFF9BB3C0);
  static const Color facebookColor = Color(0xFF3B5999);
  static const Color googleColor = Color(0xFFDE4B39);
  static const Color backgroundColor = Color(0xFFECF3F9);
}

//Original Theme
ThemeData themeLightData(BuildContext context) {
  return ThemeData(
    textTheme: GoogleFonts.nunitoSansTextTheme(
      Theme.of(context).textTheme,
    ),
    backgroundColor: Color(0xff8fb9f1),
    primaryColor: Colors.black,
    accentColor: Colors.black12,
    primaryColorDark: Color(0xff679de5),
    primaryColorLight: Color(0xfff7f9fb),
  );
}

ThemeData themeDarkData(BuildContext context) {
  return ThemeData(
    textTheme: GoogleFonts.nunitoSansTextTheme(
      Theme.of(context).textTheme,
    ),
    backgroundColor: Color(0xff8fb9f1),
    primaryColor: Color(0xff0678ea),
    accentColor: Color(0xff679de5),
    primaryColorDark: Color(0xff679de5),
    primaryColorLight: Color(0xfff7f9fb),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 4000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true;
}
