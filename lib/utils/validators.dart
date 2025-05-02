/// A collection of common form field validators.
class Validators {
  /// Validates that [value] is a non-empty string.
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
    return null;
  }

  /// Validates that [email] is in a proper email format.
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required.';
    }
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(email.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  /// Validates that [password] is at least 6 characters long.
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  /// Validates that [confirm] matches [original].
  static String? validateConfirmPassword(
      String? confirm, String? original) {
    if (confirm == null || confirm.isEmpty) {
      return 'Please confirm your password.';
    }
    if (original != confirm) {
      return 'Passwords do not match.';
    }
    return null;
  }
}
