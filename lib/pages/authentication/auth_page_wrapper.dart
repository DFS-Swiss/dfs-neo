import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:neo/hooks/use_auth_state.dart';
import 'package:neo/pages/authentication/login_widget.dart';
import 'package:neo/pages/authentication/new_password_required_widget.dart';
import 'package:neo/pages/authentication/register_widget.dart';
import 'package:neo/pages/authentication/verify_account_widget.dart';
import 'package:neo/pages/tutorial/backgroundgraphic_widget.dart';
import 'package:neo/style/theme.dart';

enum AuthPageState {
  login,
  register,
}

class AuthPageWrapper extends HookWidget {
  const AuthPageWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useState(AuthPageState.login);
    final authState = useAuthState();

    double getCurrentContainerHeight(BuildContext context) {
      double contentHeight;
      if (authState == AuthState.newPasswordRequired) {
        contentHeight = 420;
      } else if (authState == AuthState.verifyAccount) {
        contentHeight = 290;
      } else if (state.value == AuthPageState.login) {
        contentHeight = 380;
      } else if (state.value == AuthPageState.register) {
        contentHeight = 700;
      } else {
        contentHeight = 0;
      }

      return contentHeight + MediaQuery.of(context).viewPadding.bottom + 15;
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
                child: Image.asset("assets/dfsicon.png"),
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
              child: SafeArea(
                top: false,
                child: authState == AuthState.verifyAccount
                    ? VerifyAccountWidget()
                    : authState == AuthState.newPasswordRequired
                        ? NewPasswordRequired()
                        : state.value == AuthPageState.login
                            ? const LoginWidget()
                            : const RegisterWidget(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
