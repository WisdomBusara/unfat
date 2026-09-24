import 'package:bcrypt/bcrypt.dart';

class PasswordService {
  static String hash(String plainPassword) {
    return BCrypt.hashpw(plainPassword, BCrypt.gensalt(logRounds: 12));
  }

  static bool verify(String plainPassword, String hashedPassword) {
    try {
      return BCrypt.checkpw(plainPassword, hashedPassword);
    } catch (_) {
      return false;
    }
  }

  static bool isStrongEnough(String password) {
    return password.length >= 8;
  }
}
