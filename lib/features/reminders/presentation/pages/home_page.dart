import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/time_utils.dart';
import '../../domain/entities/reminder.dart';
import '../bloc/reminder_bloc.dart';
import '../bloc/reminder_event.dart';
import '../bloc/reminder_state.dart';
import '../widgets/reminder_card.dart';
import 'add_edit_reminder_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Read & Remind',
              style: theme.textTheme.headlineSmall,
            ),
            Text(
              formatReminderTime(DateTime.now()),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddEditReminderPage.open(context),
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('New reminder'),
      ),
      body: BlocListener<ReminderBloc, ReminderState>(
        listener: (context, state) {
          if (state is ReminderActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ReminderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<ReminderBloc, ReminderState>(
          builder: (context, state) {
            if (state is ReminderLoading || state is ReminderInitial) {
              return const _LoadingState();
            }

            if (state is ReminderError) {
              return _ErrorState(message: state.message);
            }

            if (state is RemindersLoaded) {
              final reminders = state.reminders;
              if (reminders.isEmpty) {
                return const _EmptyState();
              }
              return _RemindersList(reminders: reminders);
            }

            return const _EmptyState();
          },
        ),
      ),
    );
  }
}

class _RemindersList extends StatelessWidget {
  const _RemindersList({required this.reminders});

  final List<Reminder> reminders;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ReminderBloc>();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return ReminderCard(
          reminder: reminder,
          onTap: () => AddEditReminderPage.open(context, reminder: reminder),
          onDelete: () => bloc.add(DeleteReminderEvent(reminder.id)),
          onCompletedChanged: (value) => bloc.add(
            ToggleReminderCompletion(
              reminder: reminder,
              isCompleted: value ?? false,
            ),
          ),
        );
      },
      separatorBuilder: (context, _) => const SizedBox(height: 16),
      itemCount: reminders.length,
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ReminderBloc>().add(const LoadReminders()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.alarm_add_rounded, size: 56),
          const SizedBox(height: 16),
          Text(
            'Create your first mindful reminder',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Capture tasks, reading goals, or moments worth remembering. We will keep you on track with gentle nudges.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
