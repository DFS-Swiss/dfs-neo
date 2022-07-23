import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/utils/password_validator.dart';
import 'package:neo/widgets/buttons/branded_button.dart';
import 'package:neo/widgets/outlined_branded_button.dart';
import 'package:neo/widgets/password_validation_indicator.dart';

import '../../service_locator.dart';
import '../../style/theme.dart';
import '../../widgets/branded_textfield.dart';

class RegisterWidget extends HookWidget {
  final VoidCallback clickedLogin;
  const RegisterWidget({
    Key? key,
    required this.clickedLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phase = useState(0);

    final userName = useState<String?>(null);
    final email = useState<String?>(null);
    final password = useState<String?>(null);
    final error = useState<String?>(null);
    final loading = useState<bool>(false);

    handleSignup() async {
      if (userName.value != null &&
          email.value != null &&
          password.value != null &&
          PasswordValidator.isPasswordValid(password.value!)) {
        error.value = null;
        loading.value = true;
        try {
          await locator<AuthenticationService>()
              .register(userName.value!, email.value!, password.value!);
          clickedLogin();
        } on CognitoClientException catch (e) {
          if (e.message!.contains("User already exists")) {
            error.value =
                AppLocalizations.of(context)!.error_duplicate_user_name;
          } else {
            error.value = AppLocalizations.of(context)!.error_generic;
          }
          print(e);
        } catch (e) {
          error.value = AppLocalizations.of(context)!.error_generic;
        }
        loading.value = false;
      }
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text(
          AppLocalizations.of(context)!.signup_title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        phase.value == 0
            ? Column(
                children: [
                  BrandedTextfield(
                    key: ValueKey("username"),
                    onChanged: (v) => userName.value = v,
                    labelText: AppLocalizations.of(context)!.signin_username,
                    hintText:
                        AppLocalizations.of(context)!.signin_username_desc,
                    type: TextInputType.text,
                    errorText: error.value,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  BrandedTextfield(
                    key: ValueKey("email"),
                    onChanged: (v) => email.value = v,
                    labelText: AppLocalizations.of(context)!.signup_email,
                    hintText: AppLocalizations.of(context)!.signup_email_desc,
                    type: TextInputType.emailAddress,
                    errorText: error.value,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              )
            : Column(
                children: [
                  BrandedTextfield(
                    key: ValueKey("password"),
                    onChanged: (v) => password.value = v,
                    labelText: AppLocalizations.of(context)!.signup_password,
                    hintText:
                        AppLocalizations.of(context)!.signup_password_desc,
                    type: TextInputType.visiblePassword,
                    canHide: true,
                    errorText: error.value,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  PasswordValidationIndicator(password: password.value)
                ],
              ),
        const SizedBox(
          height: 46,
        ),
        Row(
          children: [
            phase.value == 0
                ? SizedBox(
                    width: 0,
                  )
                : Expanded(
                    child: OutlinedBrandedButton(
                      onPressed: () {
                        phase.value = 0;
                      },
                      text: AppLocalizations.of(context)!.signup_back,
                    ),
                  ),
            phase.value == 0
                ? SizedBox(
                    width: 0,
                  )
                : SizedBox(
                    width: 10,
                  ),
            Expanded(
              child: BrandedButton(
                loading: loading.value,
                onPressed: () {
                  if (phase.value == 0) {
                    phase.value = 1;
                    return;
                  } else {
                    handleSignup();
                  }
                },
                child: Text(
                  phase.value == 0
                      ? AppLocalizations.of(context)!.signup_continue
                      : AppLocalizations.of(context)!.signup_button,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.signup_login_link_upper,
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
              onTap: clickedLogin,
              child: Text(
                AppLocalizations.of(context)!.signup_login_link_signin,
                style: NeoTheme.of(context)!.linkTextStyle,
              ),
            ),
            Text(
              " ${AppLocalizations.of(context)!.signup_login_link_to_your_account}",
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        )
      ],
    );
  }
}
