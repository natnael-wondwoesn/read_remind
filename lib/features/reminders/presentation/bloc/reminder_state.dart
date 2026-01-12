import 'package:equatable/equatable.dart';

import '../../domain/entities/reminder.dart';

sealed class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object?> get props => [];
}

class ReminderInitial extends ReminderState {
  const ReminderInitial();
}

class ReminderLoading extends ReminderState {
  const ReminderLoading();
}

class RemindersLoaded extends ReminderState {
  const RemindersLoaded(this.reminders);

  final List<Reminder> reminders;

  @override
  List<Object?> get props => [reminders];
}

class ReminderActionSuccess extends ReminderState {
  const ReminderActionSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ReminderError extends ReminderState {
  const ReminderError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
