import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kHeading1 = GoogleFonts.openSans(fontSize: 40);
var kHeading2 = GoogleFonts.openSans(fontSize: 20);
var kHeading3 = GoogleFonts.openSans(fontSize: 30);

var kAppBarTheme = AppBarTheme(
  elevation: 0.0,
  color: Colors.white,
  iconTheme: IconThemeData(
    color: Colors.grey[500],
  ),
);

const kBackgroundColor = Color(0xFF5595FD);

var kBody_1 = GoogleFonts.openSans(
  fontSize: 25,
  color: Colors.white,
);

var kBody_2 = GoogleFonts.openSans(
  fontSize: 17,
  color: Colors.black,
);

const kHomepageBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5595FD),
      Color(0xFF1943CD),
    ],
  ),
);

const kHeadingTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: Colors.black,
);
