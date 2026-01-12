import '../../domain/entities/reminder.dart';

class ReminderModel extends Reminder {
  const ReminderModel({
    required super.id,
    required super.title,
    required super.scheduledAt,
    super.description,
    super.isCompleted,
    super.sendEmail,
    super.email,
  });

  factory ReminderModel.fromMap(Map<dynamic, dynamic> map) {
    return ReminderModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      scheduledAt: DateTime.parse(map['scheduledAt'] as String),
      isCompleted: map['isCompleted'] as bool? ?? false,
      sendEmail: map['sendEmail'] as bool? ?? false,
      email: map['email'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledAt': scheduledAt.toIso8601String(),
      'isCompleted': isCompleted,
      'sendEmail': sendEmail,
      'email': email,
    };
  }

  ReminderModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledAt,
    bool? isCompleted,
    bool? sendEmail,
    String? email,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isCompleted: isCompleted ?? this.isCompleted,
      sendEmail: sendEmail ?? this.sendEmail,
      email: email ?? this.email,
    );
  }

  factory ReminderModel.fromEntity(Reminder reminder) {
    return ReminderModel(
      id: reminder.id,
      title: reminder.title,
      description: reminder.description,
      scheduledAt: reminder.scheduledAt,
      isCompleted: reminder.isCompleted,
      sendEmail: reminder.sendEmail,
      email: reminder.email,
    );
  }
}
