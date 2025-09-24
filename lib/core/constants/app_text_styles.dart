import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/responsive_texts.dart';

class AppTextStyles {
  // Headlines
  static TextStyle headline1(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.scaledFont(32),
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle headline2(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.scaledFont(24),
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // Body text
  static TextStyle body(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.scaledFont(16),
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.scaledFont(14),
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );

  // Buttons
  static TextStyle button(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.scaledFont(16),
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle link(BuildContext context) => GoogleFonts.poppins(
    fontSize: context.scaledFont(14),
    fontWeight: FontWeight.w500,
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );
}
