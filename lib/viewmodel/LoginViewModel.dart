import 'package:cleancity/data/model/User.dart';
import 'package:cleancity/data/services/LoginService.dart';
import 'package:cleancity/sharedPref/UserStorage.dart';
import 'package:logger/logger.dart';

class LoginViewModel {
  final LoginService _loginService = LoginService();
  final logger = Logger();

  Future<User> login(String email, String password) async {
    final result = await _loginService.login(email, password);
    final user = User.fromJson(result['user']);
    await UserStorage.saveUserToSharedPref(user);
    return user;
  }
}