import 'package:cleancity/data/model/User.dart';
import 'package:cleancity/main.dart';
import 'package:cleancity/sharedPref/UserStorage.dart';
import 'package:flutter/foundation.dart';

class ProfileViewModel extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    _user = await UserStorage.loadUserFromSharedPref();

    logger.i(_user);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    await UserStorage.saveUserToSharedPref(updatedUser);
    _user = updatedUser;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await UserStorage.removeUserFromSharedPref();
    _user = null;

    _isLoading = false;
    notifyListeners();
  }
}
