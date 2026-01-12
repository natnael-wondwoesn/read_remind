import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/reminder_repository.dart';

class DeleteReminder extends UseCase<Unit, DeleteReminderParams> {
  final ReminderRepository repository;

  DeleteReminder(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteReminderParams params) {
    return repository.deleteReminder(params.id);
  }
}

class DeleteReminderParams {
  final String id;

  DeleteReminderParams(this.id);
}
