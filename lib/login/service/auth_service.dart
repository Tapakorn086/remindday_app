class AuthService {
  bool _isLoggedIn = false;

  Future<bool> isLoggedIn() async {
    // ในการใช้งานจริง คุณอาจจะต้องตรวจสอบ token ที่เก็บไว้ใน secure storage
    return _isLoggedIn;
  }

  Future<bool> login(String username, String password) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    if (username == 'user' && password == 'password') {
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    _isLoggedIn = false;
  }
}