import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/widgets/branded_button.dart';

import '../../service_locator.dart';
import '../../widgets/branded_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginWidget extends HookWidget {
  final VoidCallback clickedRegister;
  const LoginWidget({
    Key? key,
    required this.clickedRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = useState<String?>(null);
    final password = useState<String?>(null);
    final error = useState<String?>(null);
    final loading = useState(false);

    handleLogin() async {
      if (userName.value != null && password.value != null) {
        error.value = null;
        loading.value = true;
        try {
          await locator<AuthenticationService>()
              .login(userName.value!, password.value!);
        } on CognitoClientException catch (e) {
          if (e.code == "UserNotFoundException") {
            error.value = AppLocalizations.of(context)!.error_unknown_user;
          } else if (e.code == "NotAuthorizedException") {
            error.value = AppLocalizations.of(context)!.error_wrong_creds;
          } else if (e.code == "NetworkError") {
            error.value =
                AppLocalizations.of(context)!.error_server_unreachable;
          } else {
            print(e);
          }
        } catch (e) {
          print(e);
        }
        loading.value = false;
      }
    }

    return SingleChildScrollView(
      child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.signin_title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        BrandedTextfield(
          onChanged: (v) => userName.value = v,
          labelText: AppLocalizations.of(context)!.signin_username,
          hintText: AppLocalizations.of(context)!.signin_username_desc,
          type: TextInputType.emailAddress,
          errorText: error.value,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 20,
        ),
        BrandedTextfield(
          onChanged: (v) => password.value = v,
          labelText: AppLocalizations.of(context)!.signin_password,
          hintText: "**********",
          type: TextInputType.visiblePassword,
          canHide: true,
          textInputAction: TextInputAction.go,
          onContinue: (v) => handleLogin(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context)!.signin_forgot_passwort,
              style: NeoTheme.of(context)!.linkTextStyle,
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(
              child: BrandedButton(
                loading: loading.value,
                onPressed: handleLogin,
                child: Text(AppLocalizations.of(context)!.signin_button),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.signin_subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: clickedRegister,
              child: Text(
                AppLocalizations.of(context)!.signin_register,
                style: NeoTheme.of(context)!.linkTextStyle,
              ),
            ),
            Text(
              " ${AppLocalizations.of(context)!.signin_register_your_account}",
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        )
      ],
    )
    ); 
  }
}
