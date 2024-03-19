import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color ,double height) {
  return GoogleFonts.inter(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    height: height,
  );
}

// regular style

TextStyle getRegularStyle(
    {double fontSize = FontSize.s12, required Color color , required double height}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color,height);
}

// medium style

TextStyle getMediumStyle(
    {double fontSize = FontSize.s12, required Color color ,required double height}) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color,height);
}

// medium style

TextStyle getLightStyle(
    {double fontSize = FontSize.s12, required Color color,required double height}) {
  return _getTextStyle(fontSize, FontWeightManager.light, color,height);
}

// bold style

TextStyle getBoldStyle(
    {double fontSize = FontSize.s12, required Color color,required double height}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color,height);
}

// semibold style

TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12, required Color color,required double height}) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color,height);
}
// extra bold
TextStyle getExtraBoldStyle(
    {double fontSize = FontSize.s12, required Color color,required double height}) {
  return _getTextStyle(fontSize, FontWeightManager.extraBold, color,height);
}