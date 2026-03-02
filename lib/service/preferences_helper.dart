import 'dart:io';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  PreferencesHelper({required this.sharedPreferences}) {
    _getTheme();
    _getDailyReminder();
  }

  static const darkTheme = 'DARK_THEME';
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  void _getTheme() {
    _isDarkTheme = sharedPreferences.getBool(darkTheme) ?? false;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    sharedPreferences.setBool(darkTheme, value);
    _getTheme();
  }

  static const dailyReminder = 'DAILY_REMINDER';
  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  void _getDailyReminder() {
    _isDailyReminderActive = sharedPreferences.getBool(dailyReminder) ?? false;
    notifyListeners();
  }

  void enableDailyReminder(bool value) {
    sharedPreferences.setBool(dailyReminder, value);
    _getDailyReminder();

    if (Platform.isAndroid) {
      if (value) {
        final now = DateTime.now();
        var scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);
        if (now.isAfter(scheduledTime)) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }
        final initialDelay = scheduledTime.difference(now);

        Workmanager().registerPeriodicTask(
          "1",
          "daily_reminder_task",
          initialDelay: initialDelay,
          frequency: const Duration(hours: 24),
        );
      } else {
        Workmanager().cancelByUniqueName("1");
      }
    } else {
      debugPrint(
        "Penjadwalan Workmanager hanya berjalan di perangkat Android.",
      );
    }
  }
}
