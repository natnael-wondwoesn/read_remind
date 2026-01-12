import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_reminder.dart';
import '../../domain/usecases/delete_reminder.dart';
import '../../domain/usecases/get_all_reminders.dart';
import '../../domain/usecases/trigger_reminder_actions.dart';
import '../../domain/usecases/update_reminder.dart';
import 'reminder_event.dart';
import 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc({
    required this.getAllReminders,
    required this.createReminder,
    required this.updateReminder,
    required this.deleteReminder,
    required this.triggerReminderActions,
  }) : super(const ReminderInitial()) {
    on<LoadReminders>(_onLoadReminders);
    on<CreateReminderEvent>(_onCreateReminder);
    on<UpdateReminderEvent>(_onUpdateReminder);
    on<DeleteReminderEvent>(_onDeleteReminder);
    on<ToggleReminderCompletion>(_onToggleCompletion);
    on<TriggerReminderEvent>(_onTriggerReminder);
  }

  final GetAllReminders getAllReminders;
  final CreateReminder createReminder;
  final UpdateReminder updateReminder;
  final DeleteReminder deleteReminder;
  final TriggerReminderActions triggerReminderActions;

  Future<void> _onLoadReminders(
    LoadReminders event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderLoading());
    final result = await getAllReminders(const NoParams());
    result.fold(
      (failure) => emit(ReminderError(failure.message)),
      (reminders) => emit(RemindersLoaded(reminders)),
    );
  }

  Future<void> _onCreateReminder(
    CreateReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderLoading());
    final result = await createReminder(event.reminder);
    await result.fold(
      (failure) async => emit(ReminderError(failure.message)),
      (reminder) async {
        emit(const ReminderActionSuccess('Reminder created'));
        add(const LoadReminders());
        if (event.triggerNow) {
          add(TriggerReminderEvent(reminder));
        }
      },
    );
  }

  Future<void> _onUpdateReminder(
    UpdateReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderLoading());
    final result = await updateReminder(event.reminder);
    result.fold(
      (failure) => emit(ReminderError(failure.message)),
      (_) {
        emit(const ReminderActionSuccess('Reminder updated'));
        add(const LoadReminders());
      },
    );
  }

  Future<void> _onDeleteReminder(
    DeleteReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    final result = await deleteReminder(DeleteReminderParams(event.id));
    result.fold(
      (failure) => emit(ReminderError(failure.message)),
      (_) {
        emit(const ReminderActionSuccess('Reminder deleted'));
        add(const LoadReminders());
      },
    );
  }

  Future<void> _onToggleCompletion(
    ToggleReminderCompletion event,
    Emitter<ReminderState> emit,
  ) async {
    final updated = event.reminder.copyWith(isCompleted: event.isCompleted);
    add(UpdateReminderEvent(updated));
  }

  Future<void> _onTriggerReminder(
    TriggerReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    final result = await triggerReminderActions(event.reminder);
    result.fold(
      (failure) => emit(ReminderError(failure.message)),
      (_) => emit(const ReminderActionSuccess('Reminder triggered')),
    );
    add(const LoadReminders());
  }
}
