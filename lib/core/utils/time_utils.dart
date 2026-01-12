import 'package:intl/intl.dart';

String formatReminderTime(DateTime dateTime) {
  final formatter = DateFormat('EEE, MMM d • h:mm a');
  return formatter.format(dateTime);
}
