import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTheme {
  static ThemeData get light => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: TColors.primary,
    colorScheme: ColorScheme.light(primary: TColors.primary),

    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(backgroundColor: Colors.white),
  );
}
