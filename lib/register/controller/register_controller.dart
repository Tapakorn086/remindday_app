import '../service/register_service.dart';

class RegisterController {
  final RegisterService _registerService = RegisterService();

  Future<bool> register(String email, String password) async {
    try {
      return await _registerService.register(email, password);
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }
}