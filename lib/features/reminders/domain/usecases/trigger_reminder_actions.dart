import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class TriggerReminderActions extends UseCase<Unit, Reminder> {
  final ReminderRepository repository;

  TriggerReminderActions(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Reminder reminder) {
    return repository.triggerReminderActions(reminder);
  }
}
