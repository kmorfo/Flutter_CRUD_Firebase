import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    this._isLoading = value;
  }

  bool isValidForm() {
    // print(formKey.currentState?.validate());
    // print('$email $password');
    return formKey.currentState?.validate() ?? false;
  }
}
