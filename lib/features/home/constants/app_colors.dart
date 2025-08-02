import 'package:flutter/cupertino.dart';

class AppColors {
  // Light mode colors (nền trắng, chữ đen)
  static const Color lightPrimary = CupertinoColors.black;
  static const Color lightSecondary = CupertinoColors.white;
  static const Color lightBackground = CupertinoColors.white;
  static const Color lightCardBackground = CupertinoColors.systemGrey6;
  static const Color lightTextPrimary = CupertinoColors.black;
  static const Color lightTextSecondary = CupertinoColors.systemGrey;
  static const Color lightTextWhite = CupertinoColors.white;
  static const Color lightTabBarBackground = CupertinoColors.systemGrey6;
  static const Color lightTabBarActive = CupertinoColors.systemBlue;
  static const Color lightTabBarInactive = CupertinoColors.systemGrey;
  static const Color lightButtonPrimary = CupertinoColors.systemBlue;
  static const Color lightButtonText = CupertinoColors.white;
  static const Color lightIconPrimary = CupertinoColors.black;
  static const Color lightIconSecondary = CupertinoColors.systemGrey;
  static const Color lightDivider = CupertinoColors.separator;

  // Dark mode colors (nền đen, chữ trắng)
  static const Color darkPrimary = CupertinoColors.white;
  static const Color darkSecondary = CupertinoColors.black;
  static const Color darkBackground = CupertinoColors.black;
  static const Color darkCardBackground = CupertinoColors.systemGrey6;
  static const Color darkTextPrimary = CupertinoColors.white;
  static const Color darkTextSecondary = CupertinoColors.systemGrey;
  static const Color darkTextBlack = CupertinoColors.black;
  static const Color darkTabBarBackground = CupertinoColors.black;
  static const Color darkTabBarActive = CupertinoColors.white;
  static const Color darkTabBarInactive = CupertinoColors.systemGrey;
  static const Color darkButtonPrimary = CupertinoColors.white;
  static const Color darkButtonText = CupertinoColors.black;
  static const Color darkIconPrimary = CupertinoColors.white;
  static const Color darkIconSecondary = CupertinoColors.systemGrey;
  static const Color darkDivider = CupertinoColors.systemGrey4;

  // Common colors
  static const Color warning = CupertinoColors.systemOrange;
  static const Color success = CupertinoColors.systemGreen;
  static const Color error = CupertinoColors.systemRed;
  static const Color info = CupertinoColors.systemBlue;

  // Get colors based on theme mode
  static Color getPrimary(bool isDarkMode) =>
      isDarkMode ? darkPrimary : lightPrimary;
  static Color getSecondary(bool isDarkMode) =>
      isDarkMode ? darkSecondary : lightSecondary;
  static Color getBackground(bool isDarkMode) =>
      isDarkMode ? darkBackground : lightBackground;
  static Color getCardBackground(bool isDarkMode) =>
      isDarkMode ? darkCardBackground : lightCardBackground;
  static Color getTextPrimary(bool isDarkMode) =>
      isDarkMode ? darkTextPrimary : lightTextPrimary;
  static Color getTextSecondary(bool isDarkMode) =>
      isDarkMode ? darkTextSecondary : lightTextSecondary;
  static Color getTextWhite(bool isDarkMode) =>
      isDarkMode ? darkTextBlack : lightTextWhite;
  static Color getTabBarBackground(bool isDarkMode) =>
      isDarkMode ? darkTabBarBackground : lightTabBarBackground;
  static Color getTabBarActive(bool isDarkMode) =>
      isDarkMode ? darkTabBarActive : lightTabBarActive;
  static Color getTabBarInactive(bool isDarkMode) =>
      isDarkMode ? darkTabBarInactive : lightTabBarInactive;
  static Color getButtonPrimary(bool isDarkMode) =>
      isDarkMode ? darkButtonPrimary : lightButtonPrimary;
  static Color getButtonText(bool isDarkMode) =>
      isDarkMode ? darkButtonText : lightButtonText;
  static Color getIconPrimary(bool isDarkMode) =>
      isDarkMode ? darkIconPrimary : lightIconPrimary;
  static Color getIconSecondary(bool isDarkMode) =>
      isDarkMode ? darkIconSecondary : lightIconSecondary;
  static Color getDivider(bool isDarkMode) =>
      isDarkMode ? darkDivider : lightDivider;
}
