class PasswordValidator {
  static bool isPasswordValid(String password) {
    return is8Characters(password) &&
        containsLowerCaseCharacter(password) &&
        containsNumber(password) &&
        containsSpecialCharacter(password) &&
        containsUpperCaseCharacter(password);
  }

  static bool is8Characters(String password) {
    return password.length >= 8;
  }

  static bool containsNumber(String password) {
    return password.contains(RegExp("(?=.*[0-9])"));
  }

  static bool containsSpecialCharacter(String password) {
    return password.contains(RegExp("[^a-zA-Z0-9_]"));
  }

  static bool containsUpperCaseCharacter(String password) {
    return password.contains(RegExp("(?=.*[A-Z])"));
  }

  static bool containsLowerCaseCharacter(String password) {
    return password.contains(RegExp("(?=.*[a-z])"));
  }
}
