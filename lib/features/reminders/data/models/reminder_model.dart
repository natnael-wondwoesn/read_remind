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
    super.repeatInterval,
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
      repeatInterval:
          _repeatFromString(map['repeatInterval'] as String?) ?? RepeatInterval.none,
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
      'repeatInterval': repeatInterval.name,
    };
  }

  @override
  ReminderModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledAt,
    bool? isCompleted,
    bool? sendEmail,
    String? email,
    RepeatInterval? repeatInterval,
  }) {
    return ReminderModel(
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

  factory ReminderModel.fromEntity(Reminder reminder) {
    return ReminderModel(
      id: reminder.id,
      title: reminder.title,
      description: reminder.description,
      scheduledAt: reminder.scheduledAt,
      isCompleted: reminder.isCompleted,
      sendEmail: reminder.sendEmail,
      email: reminder.email,
      repeatInterval: reminder.repeatInterval,
    );
  }

  static RepeatInterval? _repeatFromString(String? value) {
    if (value == null) return null;
    return RepeatInterval.values
        .firstWhere((interval) => interval.name == value, orElse: () => RepeatInterval.none);
  }
}
