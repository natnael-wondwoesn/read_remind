import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class CreateReminder extends UseCase<Reminder, Reminder> {
  final ReminderRepository repository;

  CreateReminder(this.repository);

  @override
  Future<Either<Failure, Reminder>> call(Reminder reminder) {
    return repository.createReminder(reminder);
  }
}
