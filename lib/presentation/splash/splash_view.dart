import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/app/app_prefs.dart';
import 'package:flutter_clean_arch/presentation/resources/assets_manager.dart';
import 'package:flutter_clean_arch/presentation/resources/color_manager.dart';
import 'package:flutter_clean_arch/presentation/resources/constants_manager.dart';
import 'package:flutter_clean_arch/presentation/resources/routes_manager.dart';

import '../../app/di.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() async {
    await _appPreferences.isUserLoggedIn().then((isUserLoggedIn) {
      isUserLoggedIn
          ? Navigator.pushReplacementNamed(context, Routes.mainRoute)
          : _appPreferences
              .isOnBoardingScreenViewed()
              .then((isOnBoardingViewed) {
              isOnBoardingViewed
                  ? Navigator.pushReplacementNamed(
                      context, Routes.loginRoute)
                  : Navigator.pushReplacementNamed(
                      context, Routes.onBoardingRoute);
            });
    });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
        child: Image(
          image: AssetImage(ImageAssets.splashLogo),
        ),
      ),
    );
  }
}
