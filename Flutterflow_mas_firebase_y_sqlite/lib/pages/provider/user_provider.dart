import 'package:flutter/material.dart';
import '../../Data/entities/usuario.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLogged => _user != null;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
