class AuthenticationService {
  static final String _validEmail = 'test@example.com';
  static final String _validPassword = 'password';

  static Future<bool> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(Duration(seconds: 1));

    // Check if email and password match the hardcoded values
    return email == _validEmail && password == _validPassword;
  }
}
