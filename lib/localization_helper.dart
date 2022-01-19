import 'package:flutter/material.dart';

enum LocalizationHelper {
  english,
  korean,
  chinese,
  thailand,
  vietnamese,
  laos,
  japan,
}

extension LocalizationHelperExtension on LocalizationHelper {
  String get displayName {
    switch (this) {
      case LocalizationHelper.english:
        return 'English';
      case LocalizationHelper.korean:
        return 'Korean';
      case LocalizationHelper.chinese:
        return 'Chinese';
      case LocalizationHelper.thailand:
        return 'Thailand';
      case LocalizationHelper.vietnamese:
        return 'Vietnamese';
      case LocalizationHelper.laos:
        return 'Laos';
      case LocalizationHelper.japan:
        return 'Japanese';
    }
  }

  String get stringLocale {
    switch (this) {
      case LocalizationHelper.english:
        return 'en';
      case LocalizationHelper.korean:
        return 'ko';
      case LocalizationHelper.chinese:
        return 'zh';
      case LocalizationHelper.thailand:
        return 'th';
      case LocalizationHelper.vietnamese:
        return 'vi';
      case LocalizationHelper.laos:
        return 'lo';
      case LocalizationHelper.japan:
        return 'ja';
    }
  }

  static String defaultPath = 'assets/translations';
  static Locale defaultLocale = const Locale('en');
}
