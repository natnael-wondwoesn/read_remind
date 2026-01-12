import '../../../../core/error/exceptions.dart';
import '../models/reminder_model.dart';

abstract class ReminderEmailDataSource {
  Future<void> sendEmail(ReminderModel reminder);
}

class ReminderEmailDataSourceImpl implements ReminderEmailDataSource {
  @override
  Future<void> sendEmail(ReminderModel reminder) async {
    if (!reminder.sendEmail || reminder.email == null) {
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 300));

    final email = reminder.email;
    if (email == null || email.isEmpty) {
      throw EmailException('Email address missing');
    }
  }
}
