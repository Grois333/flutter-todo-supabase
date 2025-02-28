// lib/utils/validators.dart
bool isValidEmail(String email) {
  final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return regex.hasMatch(email);
}

bool isValidPassword(String password) {
  return password.length >= 6;
}
