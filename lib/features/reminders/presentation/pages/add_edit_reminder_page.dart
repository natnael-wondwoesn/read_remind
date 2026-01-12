import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/reminder.dart';
import '../bloc/reminder_bloc.dart';
import '../bloc/reminder_event.dart';
import '../widgets/reminder_form.dart';

class AddEditReminderPage extends StatelessWidget {
  const AddEditReminderPage({super.key, this.reminder});

  final Reminder? reminder;

  static Future<void> open(BuildContext context, {Reminder? reminder}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditReminderPage(reminder: reminder),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(reminder == null ? 'Create reminder' : 'Edit reminder'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.06),
              theme.colorScheme.secondaryContainer.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ReminderForm(
              initialReminder: reminder,
              onSubmit: (reminderData) {
                final bloc = context.read<ReminderBloc>();
                if (reminder == null) {
                  bloc.add(CreateReminderEvent(reminder: reminderData));
                } else {
                  bloc.add(UpdateReminderEvent(reminderData));
                }
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}
