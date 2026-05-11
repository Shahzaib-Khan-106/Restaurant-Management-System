class AuthService {
  static Future<bool> login(String username, String password) async {
    // ✅ Temporary bypass: always succeed
    return true;
  }

  static Future<void> logout() async {
    // For now, just a placeholder
  }

  static Future<bool> isLoggedIn() async {
    // Always return true for testing
    return true;
  }
}
