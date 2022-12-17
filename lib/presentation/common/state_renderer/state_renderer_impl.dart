import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/app/constants.dart';
import 'package:flutter_clean_arch/presentation/common/state_renderer/state_renderer.dart';

import '../../resources/strings_manager.dart';

abstract class FlowState {
  StateRendererType _getStateRendererType();

  String getMessage();
}

//Loading state (POPUP,FULL SCREEN)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String? message;

  LoadingState(
      {required this.stateRendererType, String message = AppStrings.loading});

  @override
  StateRendererType _getStateRendererType() => stateRendererType;

  @override
  String getMessage() => message ?? AppStrings.loading;
}

//Error state (POPUP,FULL SCREEN)

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState({required this.stateRendererType, required this.message});

  @override
  StateRendererType _getStateRendererType() => stateRendererType;

  @override
  String getMessage() => message ?? AppStrings.loading;
}

//Content state

class ContentState extends FlowState {
  ContentState();

  @override
  StateRendererType _getStateRendererType() => StateRendererType.contentState;

  @override
  String getMessage() => Constants.empty;
}

//Empty state (POPUP,FULL SCREEN)

class EmptyState extends FlowState {
  String message;

  EmptyState({required this.message});

  @override
  StateRendererType _getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;

  @override
  String getMessage() => message;
}

// success state
class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType _getStateRendererType() => StateRendererType.popupSuccess;
}

extension FlowStateExtention on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (_getStateRendererType() == StateRendererType.popupLoadingState) {
            // show popup loading
            showPopup(context, _getStateRendererType(), getMessage());
            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen loading state
            return StateRenderer(
                message: getMessage(),
                stateRendererType: _getStateRendererType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (_getStateRendererType() == StateRendererType.popupErrorState) {
            // show popup error
            showPopup(context, _getStateRendererType(), getMessage());
            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen error state
            return StateRenderer(
                message: getMessage(),
                stateRendererType: _getStateRendererType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: _getStateRendererType(),
              message: getMessage(),
              retryActionFunction: () {});
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      case SuccessState:
        {
          // i should check if we are showing loading popup to remove it before showing success popup
          dismissDialog(context);

          // show popup
          showPopup(context, StateRendererType.popupSuccess, getMessage(),
              title: AppStrings.success);
          // return content ui of the screen
          return contentScreenWidget;
        }
      default:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
    }
  }
}

_isCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

dismissDialog(BuildContext context) {
  if (_isCurrentDialogShowing(context)) {
    Navigator.of(context, rootNavigator: true).pop(true);
  }
}

showPopup(
    BuildContext context, StateRendererType stateRendererType, String message,
    {String title = Constants.empty}) {
  WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
      context: context,
      builder: (BuildContext context) => StateRenderer(
          stateRendererType: stateRendererType,
          message: message,
          title: title,
          retryActionFunction: () {})));
}
