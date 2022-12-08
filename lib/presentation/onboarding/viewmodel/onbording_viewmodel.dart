import 'package:flutter_clean_arch/presentation/base/baseviewmodel.dart';

class OnBoardingViewModel extends BaseViewModel with OnBoardingViewModelInputs, OnBoardingViewModelOutputs{
  @override
  void start() {
    // TODO: implement start
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void goNext() {
    // TODO: implement goNext
  }

  @override
  void goPrevious() {
    // TODO: implement goPrevious
  }

  @override
  void onPageChanged(int index) {
    // TODO: implement onPageChanged
  }
}

//inputs means the "ORDERS" that will view model receives it from view.
abstract class OnBoardingViewModelInputs {
  void goNext(); //when user clicks on right arrow or swipe left

  void goPrevious(); //when user clicks on left arrow or swipe right

  void onPageChanged(int index);
}

abstract class OnBoardingViewModelOutputs {}
