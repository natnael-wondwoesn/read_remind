import 'dart:math';

final _random = Random();

String generateId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomNumber = _random.nextInt(9999).toString().padLeft(4, '0');
  return '$timestamp$randomNumber';
}
