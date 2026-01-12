import 'package:flutter/material.dart';

import '../../../../core/utils/time_utils.dart';
import '../../domain/entities/reminder.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    this.onTap,
    this.onDelete,
    this.onCompletedChanged,
  });

  final Reminder reminder;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final ValueChanged<bool?>? onCompletedChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPast = reminder.scheduledAt.isBefore(DateTime.now());

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.9),
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              blurRadius: 25,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    reminder.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Checkbox(
                  value: reminder.isCompleted,
                  onChanged: onCompletedChanged,
                  checkColor: theme.colorScheme.primary,
                  activeColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                ),
              ],
            ),
            if (reminder.description?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  reminder.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: Colors.white.withValues(alpha: 0.85),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  formatReminderTime(reminder.scheduledAt),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                if (isPast)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Past due',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
