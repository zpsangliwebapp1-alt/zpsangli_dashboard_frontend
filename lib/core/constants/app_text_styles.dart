import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_fonts.dart';

class AppTextStyles {
  // Headlines
  static TextStyle headline1(BuildContext context) => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: AppFonts.bold,
    color: Colors.black,
  );

  static TextStyle headline2(BuildContext context) => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: AppFonts.semiBold,
    color: Colors.black,
  );

  // Body
  static TextStyle body(BuildContext context) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: AppFonts.regular,
    color: Colors.black87,
  );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: AppFonts.regular,
    color: Colors.black54,
  );

  // Buttons
  static TextStyle button(BuildContext context) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: AppFonts.semiBold,
    color: Colors.white,
  );

  static TextStyle link(BuildContext context) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: AppFonts.medium,
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );
}
