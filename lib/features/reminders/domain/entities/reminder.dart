import 'package:equatable/equatable.dart';

enum RepeatInterval { none, daily, weekly, monthly }

extension RepeatIntervalX on RepeatInterval {
  String get label {
    switch (this) {
      case RepeatInterval.daily:
        return 'Daily';
      case RepeatInterval.weekly:
        return 'Weekly';
      case RepeatInterval.monthly:
        return 'Monthly';
      case RepeatInterval.none:
        return 'None';
    }
  }
}

class Reminder extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime scheduledAt;
  final bool isCompleted;
  final bool sendEmail;
  final String? email;
  final RepeatInterval repeatInterval;

  const Reminder({
    required this.id,
    required this.title,
    required this.scheduledAt,
    this.description,
    this.isCompleted = false,
    this.sendEmail = false,
    this.email,
    this.repeatInterval = RepeatInterval.none,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledAt,
    bool? isCompleted,
    bool? sendEmail,
    String? email,
    RepeatInterval? repeatInterval,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isCompleted: isCompleted ?? this.isCompleted,
      sendEmail: sendEmail ?? this.sendEmail,
      email: email ?? this.email,
      repeatInterval: repeatInterval ?? this.repeatInterval,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        scheduledAt,
        isCompleted,
        sendEmail,
        email,
        repeatInterval,
      ];
}
