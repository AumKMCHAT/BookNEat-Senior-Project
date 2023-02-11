import 'package:book_n_eat_senior_project/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:book_n_eat_senior_project/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMedthods _authMedthods = AuthMedthods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMedthods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
