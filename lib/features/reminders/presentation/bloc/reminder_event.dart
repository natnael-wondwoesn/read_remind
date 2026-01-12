import 'package:equatable/equatable.dart';

import '../../domain/entities/reminder.dart';

sealed class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object?> get props => [];
}

class LoadReminders extends ReminderEvent {
  const LoadReminders();
}

class CreateReminderEvent extends ReminderEvent {
  const CreateReminderEvent({
    required this.reminder,
    this.triggerNow = false,
  });

  final Reminder reminder;
  final bool triggerNow;

  @override
  List<Object?> get props => [reminder, triggerNow];
}

class UpdateReminderEvent extends ReminderEvent {
  const UpdateReminderEvent(this.reminder);

  final Reminder reminder;

  @override
  List<Object?> get props => [reminder];
}

class DeleteReminderEvent extends ReminderEvent {
  const DeleteReminderEvent(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class ToggleReminderCompletion extends ReminderEvent {
  const ToggleReminderCompletion({
    required this.reminder,
    required this.isCompleted,
  });

  final Reminder reminder;
  final bool isCompleted;

  @override
  List<Object?> get props => [reminder, isCompleted];
}

class TriggerReminderEvent extends ReminderEvent {
  const TriggerReminderEvent(this.reminder);

  final Reminder reminder;

  @override
  List<Object?> get props => [reminder];
}
