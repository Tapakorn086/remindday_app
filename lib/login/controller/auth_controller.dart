import '../../login/service/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    try {
      await _authService.login(email, password);
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}