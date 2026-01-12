import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class UpdateReminder extends UseCase<Reminder, Reminder> {
  final ReminderRepository repository;

  UpdateReminder(this.repository);

  @override
  Future<Either<Failure, Reminder>> call(Reminder reminder) {
    return repository.updateReminder(reminder);
  }
}
