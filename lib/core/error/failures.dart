import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NotificationFailure extends Failure {
  const NotificationFailure(super.message);
}

class EmailFailure extends Failure {
  const EmailFailure(super.message);
}
