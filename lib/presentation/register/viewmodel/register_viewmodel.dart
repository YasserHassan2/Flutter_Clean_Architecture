import 'dart:async';
import 'dart:io';

import 'package:flutter_clean_arch/app/functions.dart';
import 'package:flutter_clean_arch/domain/usecase/register_use_case.dart';
import 'package:flutter_clean_arch/presentation/base/baseviewmodel.dart';
import 'package:flutter_clean_arch/presentation/common/state_renderer/state_renderer.dart';
import 'package:flutter_clean_arch/presentation/common/state_renderer/state_renderer_impl.dart';

import '../../common/freezed_data_classes.dart';
import '../../resources/strings_manager.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInput, RegisterViewModelOutput {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _mobileNumberStreamController =
      StreamController<String>.broadcast();
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _profilePictureStreamController =
      StreamController<File>.broadcast();
  final StreamController _isAllInputValid = StreamController<void>.broadcast();
  final StreamController _isUserRegisteredInSuccessfullyStreamController =
      StreamController<bool>.broadcast();

  final RegisterUseCase _registerUseCase;
  var registerObject = RegisterObject("", "", "", "", "", "");

  RegisterViewModel(this._registerUseCase);

  @override
  void start() {}

  @override
  void dispose() {
    _userNameStreamController.close();
    _mobileNumberStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePictureStreamController.close();
    _isAllInputValid.close();
    _isUserRegisteredInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputMobileNumber => _mobileNumberStreamController.sink;

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputProfilePicture => _profilePictureStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Stream<bool> get outEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outErrorEmailValid => outEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.invalidEmail);

  @override
  Stream<String?> get outErrorMobileNumberValid => outMobileNumberValid
      .map((event) => event ? null : AppStrings.mobileNumberInvalid);

  @override
  Stream<String?> get outErrorPasswordValid => outPasswordValid
      .map((event) => event ? null : AppStrings.passwordInvalid);

  @override
  Stream<bool> get outUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<String?> get outErrorUserNameValid => outUserNameValid
      .map((isUserName) => isUserName ? null : AppStrings.userNameInvalid);

  @override
  Stream<bool> get outMobileNumberValid => _mobileNumberStreamController.stream
      .map((event) => _isMobileNumberValid(event));

  @override
  Stream<bool> get outPasswordValid =>
      _passwordStreamController.stream.map((event) => _isPasswordValid(event));

  @override
  Stream<File> get outProfilePictureValid =>
      _profilePictureStreamController.stream.map((event) => event);

  @override
  Stream<bool> get outputAreAllInputsValid =>
      _isAllInputValid.stream.map((event) => _areAllInputsValid());

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _registerUseCase.execute(RegisterUseCaseInput(
            registerObject.userName,
            registerObject.countryMobileCode,
            registerObject.mobileNumber,
            registerObject.email,
            registerObject.password,
            registerObject.profilePicture)))
        .fold(
            (failure) => {
                  // left -> failure
                  inputState.add(ErrorState(
                      stateRendererType: StateRendererType.popupErrorState,
                      message: failure.message))
                }, (data) {
      // right -> data (success)
      // content
      inputState.add(ContentState());
      // navigate to main screen
      _isUserRegisteredInSuccessfullyStreamController.add(true);
    });
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      //  update register view object
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      // reset code value in register view object
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      //  update register view object
      registerObject = registerObject.copyWith(email: email);
    } else {
      // reset email value in register view object
      registerObject = registerObject.copyWith(email: "");
    }
    validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      //  update register view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // reset mobileNumber value in register view object
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    validate();
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      //  update register view object
      registerObject = registerObject.copyWith(password: password);
    } else {
      // reset password value in register view object
      registerObject = registerObject.copyWith(password: "");
    }
    validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      //  update register view object
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      // reset profilePicture value in register view object
      registerObject = registerObject.copyWith(profilePicture: "");
    }
    validate();
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      //  update register view object
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(userName: "");
    }
    validate();
  }

  // --  private functions

  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _areAllInputsValid() {
    return registerObject.countryMobileCode.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.userName.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty;
  }

  validate() {
    _isAllInputValid.add(null);
  }
}

abstract class RegisterViewModelInput {
  Sink get inputUserName;

  Sink get inputMobileNumber;

  Sink get inputEmail;

  Sink get inputPassword;

  Sink get inputProfilePicture;

  register();

  setUserName(String userName);

  setMobileNumber(String mobileNumber);

  setCountryCode(String countryCode);

  setEmail(String email);

  setPassword(String password);

  setProfilePicture(File profilePicture);
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outUserNameValid;

  Stream<String?> get outErrorUserNameValid;

  Stream<bool> get outMobileNumberValid;

  Stream<String?> get outErrorMobileNumberValid;

  Stream<bool> get outEmailValid;

  Stream<String?> get outErrorEmailValid;

  Stream<bool> get outPasswordValid;

  Stream<String?> get outErrorPasswordValid;

  Stream<File> get outProfilePictureValid;

  Stream<bool> get outputAreAllInputsValid;
}
