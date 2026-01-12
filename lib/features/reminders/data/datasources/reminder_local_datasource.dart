import 'package:hive/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../models/reminder_model.dart';

abstract class ReminderLocalDataSource {
  Future<List<ReminderModel>> getReminders();
  Future<ReminderModel> createReminder(ReminderModel reminder);
  Future<ReminderModel> updateReminder(ReminderModel reminder);
  Future<void> deleteReminder(String id);
}

class ReminderLocalDataSourceImpl implements ReminderLocalDataSource {
  ReminderLocalDataSourceImpl({required this.box});

  final Box<Map> box;

  @override
  Future<ReminderModel> createReminder(ReminderModel reminder) async {
    await box.put(reminder.id, reminder.toMap());
    return reminder;
  }

  @override
  Future<void> deleteReminder(String id) async {
    if (!box.containsKey(id)) {
      throw CacheException('Reminder not found');
    }
    await box.delete(id);
  }

  @override
  Future<List<ReminderModel>> getReminders() async {
    final values = box.values
        .map((data) => ReminderModel.fromMap(Map<dynamic, dynamic>.from(data)))
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return values;
  }

  @override
  Future<ReminderModel> updateReminder(ReminderModel reminder) async {
    if (!box.containsKey(reminder.id)) {
      throw CacheException('Reminder not found');
    }
    await box.put(reminder.id, reminder.toMap());
    return reminder;
  }
}
