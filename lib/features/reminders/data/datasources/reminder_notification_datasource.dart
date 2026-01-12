import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/error/exceptions.dart';
import '../models/reminder_model.dart';

abstract class ReminderNotificationDataSource {
  Future<void> scheduleReminder(ReminderModel reminder);
  Future<void> cancelReminder(String id);
}

class ReminderNotificationDataSourceImpl
    implements ReminderNotificationDataSource {
  ReminderNotificationDataSourceImpl({
    required this.notificationsPlugin,
  });

  final FlutterLocalNotificationsPlugin notificationsPlugin;

  @override
  Future<void> cancelReminder(String id) async {
    await notificationsPlugin.cancel(id.hashCode);
  }

  @override
  Future<void> scheduleReminder(ReminderModel reminder) async {
    final scheduledDate = tz.TZDateTime.from(reminder.scheduledAt, tz.local);

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminders_channel',
        'Reminders',
        channelDescription: 'Notification channel for reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    final result = await notificationsPlugin.zonedSchedule(
      reminder.id.hashCode,
      reminder.title,
      reminder.description ?? 'Tap to view reminder',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: reminder.id,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );

    if (result == null) {
      throw NotificationException('Unable to schedule notification');
    }
  }
}
