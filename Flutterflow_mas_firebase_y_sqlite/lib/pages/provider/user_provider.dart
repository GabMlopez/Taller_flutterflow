import 'package:flutter/material.dart';
import '../../Data/entities/usuario.dart';
import '../../Data/entities/chat_user.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  ChatUser? chat_user;

  UserModel? get user => _user;
  bool get isLogged => _user != null;

  void setUser(UserModel user, ChatUser chat_user) {
    _user = user;
    this.chat_user = chat_user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    chat_user = null;
    notifyListeners();
  }
}
