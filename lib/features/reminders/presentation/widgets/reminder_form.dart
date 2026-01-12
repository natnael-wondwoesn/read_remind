import 'package:flutter/material.dart';

import '../../../../core/utils/id_generator.dart';
import '../../../../core/utils/time_utils.dart';
import '../../domain/entities/reminder.dart';

class ReminderForm extends StatefulWidget {
  const ReminderForm({
    super.key,
    this.initialReminder,
    required this.onSubmit,
    this.isSaving = false,
  });

  final Reminder? initialReminder;
  final void Function(Reminder reminder) onSubmit;
  final bool isSaving;

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  late DateTime _scheduledAt;
  late bool _sendEmail;

  @override
  void initState() {
    super.initState();
    final reminder = widget.initialReminder;
    _titleController = TextEditingController(text: reminder?.title ?? '');
    _descriptionController =
        TextEditingController(text: reminder?.description ?? '');
    _emailController = TextEditingController(text: reminder?.email ?? '');
    _scheduledAt = reminder?.scheduledAt ?? DateTime.now().add(const Duration(hours: 1));
    _sendEmail = reminder?.sendEmail ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final context = this.context;
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null) return;
    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final reminder = Reminder(
      id: widget.initialReminder?.id ?? generateId(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      scheduledAt: _scheduledAt,
      sendEmail: _sendEmail,
      email: _sendEmail ? _emailController.text.trim() : null,
      isCompleted: widget.initialReminder?.isCompleted ?? false,
    );
    widget.onSubmit(reminder);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Reminder title',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickDateTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reminder time',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatReminderTime(_scheduledAt),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: _sendEmail,
            onChanged: (value) => setState(() => _sendEmail = value),
            title: const Text('Send email reminder'),
            subtitle: const Text('Receive a gentle nudge in your inbox'),
          ),
          if (_sendEmail)
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: (value) {
                if (!_sendEmail) return null;
                if (value == null || value.isEmpty) {
                  return 'Enter an email';
                }
                if (!value.contains('@')) {
                  return 'Invalid email';
                }
                return null;
              },
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: widget.isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(widget.initialReminder == null
                    ? 'Create reminder'
                    : 'Update reminder'),
              ),
              onPressed: widget.isSaving ? null : _submit,
            ),
          ),
        ],
      ),
    );
  }
}
