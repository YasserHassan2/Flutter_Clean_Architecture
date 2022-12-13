import 'dart:async';
import 'dart:math';

import 'package:flutter_clean_arch/domain/usecase/login_usecase.dart';
import 'package:flutter_clean_arch/presentation/base/baseviewmodel.dart';
import 'package:flutter_clean_arch/presentation/common/freezed_data_classes.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInput, LoginViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  var loginObject = LoginObject("", "");

  //inputs
  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
  }

  @override
  void start() {}

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  login() async {
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
            (failure) => {
                  //left - > failure
                },
            (data) => {
                  //right - > success
                });
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
  }

  //outputs

  @override
  // TODO: implement isPasswordValid
  Stream<bool> get isPasswordValid =>
      _passwordStreamController.stream.map((password) => password);

  @override
  // TODO: implement isUserNameValid
  Stream<bool> get isUserNameValid =>
      _userNameStreamController.stream.map((userName) => userName);

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }
//
// bool _areAllInputsValid() {
//   return _isPasswordValid(loginObject.password) &&
//       _isUserNameValid(loginObject.userName);
// }
// }
}

abstract class LoginViewModelInput {
  setUserName(String userName);

  setPassword(String password);

  login();

  Sink get inputUserName;

  Sink get inputPassword;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get isUserNameValid;

  Stream<bool> get isPasswordValid;
}
