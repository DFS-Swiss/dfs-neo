import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/widgets/buttons/branded_outline_button.dart';
import 'package:neo/widgets/password_validation_indicator.dart';

import '../../widgets/branded_textfield.dart';
import '../../widgets/buttons/branded_button.dart';

class ForgotPassword extends HookWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phase = useState(1);
    return phase.value == 1
        ? _ForgotPasswordPhase1(
            phaseComplete: () => phase.value = 2,
          )
        : _ForgotPasswordPhase2(
            phaseComplete: () => Navigator.pop(context),
          );
  }
}

class _ForgotPasswordPhase2 extends HookWidget {
  final VoidCallback phaseComplete;

  const _ForgotPasswordPhase2({
    Key? key,
    required this.phaseComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newPassword = useState<String?>(null);
    final code = useState<String?>(null);
    final loading = useState(false);
    final error = useState<String?>(null);

    handleSubmit() async {
      if (newPassword.value == null ||
          newPassword.value == "" ||
          code.value == null ||
          code.value == "") {
        return;
      }
      loading.value = true;
      error.value = null;
      try {
        await locator<AuthenticationService>()
            .completeForgotPassword(code.value!, newPassword.value!);
        phaseComplete();
      } on CognitoClientException catch (e) {
        if (e.code == "UserNotFoundException") {
          error.value =
              AppLocalizations.of(context)!.forgot_password_user_not_found;
        }
        print(e);
      } catch (e) {
        print(e);
      } finally {
        loading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppLocalizations.of(context)!.forgot_password_title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              AppLocalizations.of(context)!.forgot_password_phase_2_desc,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
              height: 20,
            ),
            BrandedTextfield(
              onChanged: (v) => code.value = v,
              labelText: AppLocalizations.of(context)!.forgot_password_code,
              hintText: AppLocalizations.of(context)!.forgot_password_code_desc,
              type: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 20,
            ),
            BrandedTextfield(
              onChanged: (v) => newPassword.value = v,
              labelText: AppLocalizations.of(context)!.change_password_new,
              hintText: AppLocalizations.of(context)!.signup_password_desc,
              canHide: true,
              type: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(
              height: 10,
            ),
            PasswordValidationIndicator(password: newPassword.value),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: BrandedButton(
                    loading: loading.value,
                    onPressed: handleSubmit,
                    child: Text(
                      AppLocalizations.of(context)!.forgot_password_continue,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordPhase1 extends HookWidget {
  final VoidCallback phaseComplete;
  const _ForgotPasswordPhase1({
    Key? key,
    required this.phaseComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = useState<String?>(null);
    final error = useState<String?>(null);
    final loading = useState(false);

    handleSubmit() async {
      phaseComplete();
      if (userName.value == null || userName.value == "") {
        return;
      }
      loading.value = true;
      error.value = null;
      try {
        await locator<AuthenticationService>()
            .initForgotPassword(userName.value!);
        phaseComplete();
      } on CognitoClientException catch (e) {
        if (e.code == "UserNotFoundException") {
          error.value =
              AppLocalizations.of(context)!.forgot_password_user_not_found;
        }
        print(e);
      }
      loading.value = false;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppLocalizations.of(context)!.forgot_password_title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            AppLocalizations.of(context)!.force_change_password_desc,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(
            height: 20,
          ),
          BrandedTextfield(
            onChanged: (v) => userName.value = v,
            labelText: AppLocalizations.of(context)!.signin_username,
            hintText: AppLocalizations.of(context)!.signin_username_desc,
            type: TextInputType.emailAddress,
            errorText: error.value,
            textInputAction: TextInputAction.done,
            onContinue: (v) => handleSubmit(),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Expanded(
                child: BrandedOutlineButton(
                  onPressed: () =>
                      locator<AppStateService>().state = AppState.signedOut,
                  child: Text(
                    AppLocalizations.of(context)!.signup_back,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: BrandedButton(
                  loading: loading.value,
                  onPressed: handleSubmit,
                  child: Text(
                    AppLocalizations.of(context)!.forgot_password_continue,
                  ),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
