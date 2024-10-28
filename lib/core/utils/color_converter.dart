import 'package:flutter/material.dart';

String colorToHexString(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0')}';
}

Color hexStringToColor(String hexString) {
  hexString = hexString.replaceFirst('#', '');
  int colorValue = int.parse(hexString, radix: 16);
  return Color(colorValue);
}
