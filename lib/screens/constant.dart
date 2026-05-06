
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  static const Color black = Colors.black87;
  static const Color grey = Colors.grey;
}

class AppStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: AppColors.black,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: AppColors.grey,
  );
}
