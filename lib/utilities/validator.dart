import 'package:couchya/utilities/constants.dart';

class Validator {
  Validator._();
  static String email(value) {
    if (value.length == 0) return "Email cannot be empty";
    if (!emailRegex.hasMatch(value)) return "Please enter a valid email!";
    return null;
  }

  static String password(value) {
    if (value.length < 8) return "Password must contain at least 8 characters!";
    return null;
  }

  static String username(value) {
    if (value.length < 4) return "Name must contain at least 4 letters!";
    return null;
  }

  static String phone(value) {
    if (value.length == 0) return "Phone cannot be empty";
    if (!phoneRegex.hasMatch(value)) return "Please enter a valid phone!";
    return null;
  }
}
