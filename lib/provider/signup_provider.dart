import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupProvider extends ChangeNotifier {
  String emailErrorText = "";
  String passwordErrorText = "";

  void onChangedEmailValidation(String email) {
    if (email.toString().isEmpty) {
      emailErrorText = "Email Can not be Null";
    } else if (!(email.contains("@"))) {
      emailErrorText = "Email should be Contain @ symbol";
    } else {
      emailErrorText = "";
    }
    notifyListeners();
  }

  void onChangedPasswordValidation(String password) {
    if (password.isEmpty) {
      passwordErrorText = "Password Should not be Empty";
    } else if (password.length < 6) {
      passwordErrorText = "Length should be 6 Character";
    } else {
      passwordErrorText = "";
    }
    notifyListeners();
  }

  bool validateBothEmailAndPassword(String email, String password) {
    onChangedEmailValidation(email);
    onChangedPasswordValidation(password);

    return emailErrorText.isEmpty && passwordErrorText.isEmpty;
  }
}

final signupProvider = ChangeNotifierProvider((ref) {
  return SignupProvider();
});
