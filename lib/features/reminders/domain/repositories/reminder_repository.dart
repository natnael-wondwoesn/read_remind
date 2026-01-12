import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<Either<Failure, List<Reminder>>> getAllReminders();
  Future<Either<Failure, Reminder>> createReminder(Reminder reminder);
  Future<Either<Failure, Reminder>> updateReminder(Reminder reminder);
  Future<Either<Failure, Unit>> deleteReminder(String id);
  Future<Either<Failure, Unit>> triggerReminderActions(Reminder reminder);
}
