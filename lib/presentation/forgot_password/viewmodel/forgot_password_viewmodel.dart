import 'dart:async';

import 'package:flutter_clean_arch/domain/usecase/forgot_password_usecase.dart';
import 'package:flutter_clean_arch/presentation/base/baseviewmodel.dart';
import 'package:flutter_clean_arch/presentation/common/state_renderer/state_renderer_impl.dart';

import '../../../app/functions.dart';
import '../../common/state_renderer/state_renderer.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInput, ForgotPasswordViewModelOutput {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();

  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  var email = "";

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  void forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(email)).fold((failure) {
      inputState.add(ErrorState(
          stateRendererType: StateRendererType.popupErrorState,
          message: failure.message));
    }, (supportMessage) {
      inputState.add(SuccessState(supportMessage));
    });
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllValid => _isAllInputValidStreamController.sink;

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((event) => isEmailValid(email));

  @override
  Stream<bool> get outputIsAllInputValid =>
      _isAllInputValidStreamController.stream
          .map((event) => _isAllInputValid());

  @override
  void setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  _isAllInputValid() {
    return isEmailValid(email);
  }

  _validate() {
    inputIsAllValid.add(null);
  }
}

abstract class ForgotPasswordViewModelInput {
  void forgotPassword();

  void setEmail(String email);

  Sink get inputEmail;

  Sink get inputIsAllValid;
}

abstract class ForgotPasswordViewModelOutput {
  Stream<bool> get outputIsEmailValid;

  Stream<bool> get outputIsAllInputValid;
}
