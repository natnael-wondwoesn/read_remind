import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_email_datasource.dart';
import '../datasources/reminder_local_datasource.dart';
import '../datasources/reminder_notification_datasource.dart';
import '../models/reminder_model.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl({
    required this.localDataSource,
    required this.notificationDataSource,
    required this.emailDataSource,
  });

  final ReminderLocalDataSource localDataSource;
  final ReminderNotificationDataSource notificationDataSource;
  final ReminderEmailDataSource emailDataSource;

  @override
  Future<Either<Failure, Reminder>> createReminder(Reminder reminder) async {
    return _guard(() async {
      final model = ReminderModel.fromEntity(reminder);
      final created = await localDataSource.createReminder(model);
      await notificationDataSource.scheduleReminder(created);
      await emailDataSource.sendEmail(created);
      return created;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteReminder(String id) async {
    return _guard(() async {
      await localDataSource.deleteReminder(id);
      await notificationDataSource.cancelReminder(id);
      return unit;
    });
  }

  @override
  Future<Either<Failure, List<Reminder>>> getAllReminders() async {
    return _guard(localDataSource.getReminders);
  }

  @override
  Future<Either<Failure, Reminder>> updateReminder(Reminder reminder) async {
    return _guard(() async {
      final updated = await localDataSource.updateReminder(
        ReminderModel.fromEntity(reminder),
      );
      await notificationDataSource.scheduleReminder(updated);
      return updated;
    });
  }

  @override
  Future<Either<Failure, Unit>> triggerReminderActions(Reminder reminder) async {
    return _guard(() async {
      final model = ReminderModel.fromEntity(reminder);
      await notificationDataSource.scheduleReminder(model);
      await emailDataSource.sendEmail(model);
      return unit;
    });
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
    try {
      final result = await run();
      return Right(result);
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message));
    } on NotificationException catch (error) {
      return Left(NotificationFailure(error.message));
    } on EmailException catch (error) {
      return Left(EmailFailure(error.message));
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }
}
