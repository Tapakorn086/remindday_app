class RegisterService {
  Future<bool> register(String email, String password) async {
    // ในการใช้งานจริง คุณควรเชื่อมต่อกับ API หรือระบบลงทะเบียนที่เหมาะสม
    await Future.delayed(Duration(seconds: 2)); // จำลองการเชื่อมต่อเครือข่าย
    
    // ตรวจสอบว่าอีเมลไม่ซ้ำกับที่มีอยู่ในระบบ (ในที่นี้เป็นเพียงตัวอย่าง)
    if (email == "existing@example.com") {
      return false; // อีเมลนี้มีในระบบแล้ว
    }
    
    // บันทึกข้อมูลผู้ใช้ใหม่
    print('User registered: $email');
    return true;
  }
}