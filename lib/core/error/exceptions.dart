class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache Exception']);
}

class NotificationException implements Exception {
  final String message;

  NotificationException([this.message = 'Notification Exception']);
}

class EmailException implements Exception {
  final String message;

  EmailException([this.message = 'Email Exception']);
}
