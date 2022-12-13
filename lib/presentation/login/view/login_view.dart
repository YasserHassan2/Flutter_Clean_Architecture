import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/presentation/login/viewmodel/login_loginViewModel.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel _loginViewModel = LoginViewModel(_loginUseCase);

  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _bing() {
    _loginViewModel.start();
    _userNameTextEditingController.addListener(
        () => _loginViewModel.setUserName(_userNameTextEditingController.text));
    _passwordTextEditingController.addListener(
        () => _loginViewModel.setPassword(_passwordTextEditingController.text));
  }

  @override
  void initState() {
    _bing();
    super.initState();
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder(
        stream: _loginViewModel.outputState,
        builder: (context, snapshot) {
          // return snapshot.data?.getScreenWidget(context, _getContentWidget(),
          //         () {
          //       _loginViewModel.login();
          //     }) ??
          //     _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
        padding: const EdgeInsets.only(top: AppPadding.p100),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(
                    child: Image(image: AssetImage(ImageAssets.splashLogo))),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                      stream: _loginViewModel.outIsUserNameValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _userNameTextEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.username,
                              labelText: AppStrings.username,
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.usernameError),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                      stream: _loginViewModel.outIsPasswordValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordTextEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.password,
                              labelText: AppStrings.password,
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.passwordError),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                      stream: _loginViewModel.outAreAllInputsValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s40,
                          child: ElevatedButton(
                              onPressed: (snapshot.data ?? false)
                                  ? () {
                                _loginViewModel.login();
                              }
                                  : null,
                              child: const Text(AppStrings.login)),
                        );
                      }),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: AppPadding.p8,
                        left: AppPadding.p28,
                        right: AppPadding.p28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.forgotPasswordRoute);
                          },
                          child: Text(AppStrings.forgetPassword,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.registerRoute);
                          },
                          child: Text(AppStrings.registerText,
                              style: Theme.of(context).textTheme.titleMedium),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
