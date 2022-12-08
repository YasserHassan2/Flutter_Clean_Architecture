abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  //shared variables and functions that will be used through any view model.

}

abstract class BaseViewModelInputs {
  void start(); //start view model task

  void dispose(); //kill view model tasks (streams, background services)
}

abstract class BaseViewModelOutputs {}
