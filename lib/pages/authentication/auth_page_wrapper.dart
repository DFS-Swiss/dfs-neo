import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/hooks/use_auth_state.dart';
import 'package:neo/pages/authentication/login_widget.dart';
import 'package:neo/pages/authentication/new_password_required_widget.dart';
import 'package:neo/pages/authentication/register_widget.dart';
import 'package:neo/pages/authentication/verify_account_widget.dart';
import 'package:neo/pages/tutorial/backgroundgraphic_widget.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/style/theme.dart';

import '../../constants/ui.dart';

enum AuthPageState {
  login,
  register,
}

class AuthPageWrapper extends HookWidget {
  final AppStateService appStateService = locator<AppStateService>();
  AuthPageWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = useAppState();
    double getCurrentContainerHeight(BuildContext context) {
      double contentHeight;
      if (authState == AppState.newPasswordRequired) {
        contentHeight = AUTH_NEWPW_CONTAINTER_HEIGHT;
      } else if (authState == AppState.verifyAccount) {
        contentHeight = AUTH_VERIFYACC_CONTAINTER_HEIGHT;
      } else if (authState == AppState.signedOut) {
        contentHeight = AUTH_LOGIN_CONTAINTER_HEIGHT;
      } else if (authState == AppState.register) {
        contentHeight = AUTH_REGISTER_CONTAINTER_HEIGHT;
      } else {
        contentHeight = 0;
      }

      return contentHeight + MediaQuery.of(context).viewPadding.bottom + 20;
    }

    return Scaffold(
      body: Stack(
        children: [
          BackgroundGraphic(drawCircle: false),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: getCurrentContainerHeight(context) -
                MediaQuery.of(context).viewInsets.bottom,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: MediaQuery.of(context).size.height * 0.1),
                child: Image.asset("assets/dfsicon_full.png"),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    NeoTheme.of(context)!.secondaryBorderRadius,
                  ),
                ),
              ),
              height: getCurrentContainerHeight(context),
              padding: const EdgeInsets.all(20),
              //duration: const Duration(milliseconds: 300),
              child: authState == AppState.verifyAccount
                  ? VerifyAccountWidget()
                  : authState == AppState.newPasswordRequired
                      ? NewPasswordRequired()
                      : authState == AppState.signedOut
                          ? LoginWidget(
                              clickedRegister: () =>
                                  appStateService.state = AppState.register,
                            )
                          : RegisterWidget(
                              clickedLogin: () =>
                                  appStateService.state = AppState.signedOut,
                            ),
            ),
          )
        ],
      ),
    );
  }
}
