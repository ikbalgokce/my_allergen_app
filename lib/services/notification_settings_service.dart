import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsService {
  static const int _defaultReminderBeforeMinutes = 15;

  String _reminderBeforeKey(int userId) => 'notif_reminder_before_$userId';

  Future<int> getReminderBeforeMinutes(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_reminderBeforeKey(userId)) ?? _defaultReminderBeforeMinutes;
  }

  Future<void> setReminderBeforeMinutes({
    required int userId,
    required int minutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_reminderBeforeKey(userId), minutes);
  }
}
