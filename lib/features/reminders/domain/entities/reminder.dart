import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime scheduledAt;
  final bool isCompleted;
  final bool sendEmail;
  final String? email;

  const Reminder({
    required this.id,
    required this.title,
    required this.scheduledAt,
    this.description,
    this.isCompleted = false,
    this.sendEmail = false,
    this.email,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledAt,
    bool? isCompleted,
    bool? sendEmail,
    String? email,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isCompleted: isCompleted ?? this.isCompleted,
      sendEmail: sendEmail ?? this.sendEmail,
      email: email ?? this.email,
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
      ];
}
