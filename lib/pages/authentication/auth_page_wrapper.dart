import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/authentication/login_widget.dart';
import 'package:neo/pages/authentication/register_widget.dart';
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

    return Scaffold(
      body: Column(
        children: [
          const Expanded(
              child: FlutterLogo(
            size: 120,
          )),
          AnimatedContainer(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: NeoTheme.of(context)!.primaryBorderRadius,
            ),
            height: state.value == AuthPageState.login ? 400 : 700,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            duration: const Duration(milliseconds: 300),
            child: state.value == AuthPageState.login
                ? const LoginWidget()
                : const RegisterWidget(),
          )
        ],
      ),
    );
  }
}
