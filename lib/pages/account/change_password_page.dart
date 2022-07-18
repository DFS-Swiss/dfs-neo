// ignore_for_file: use_build_context_synchronously

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/utils/password_validator.dart';
import 'package:neo/widgets/branded_button.dart';
import 'package:neo/widgets/branded_textfield.dart';
import 'package:neo/widgets/password_validation_indicator.dart';

class ChangePasswordPage extends HookWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final oldPassword = useState<String?>(null);
    final newPassword = useState<String?>(null);
    final newPasswordRepeat = useState<String?>(null);
    final loading = useState(false);
    final mounted = useIsMounted();

    handleSubmit() async {
      if (oldPassword.value != null &&
          newPassword.value != null &&
          PasswordValidator.isPasswordValid(newPassword.value!)) {
        loading.value = true;
        try {
          await locator<AuthenticationService>().changePassword(
            oldPassword.value!,
            newPassword.value!,
          );
          if (!mounted()) return;
          Navigator.pop(context);
        } on CognitoClientException catch (e) {
          print(e);
          if (e.code == "NotAuthorizedException") {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title:
                    Text(AppLocalizations.of(context)!.change_password_error),
                content: Text(AppLocalizations.of(context)!
                    .change_password_error_wrong_pw),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  )
                ],
              ),
            );
          }
        }
        loading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.change_password_title),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                children: [
                  BrandedTextfield(
                    labelText:
                        AppLocalizations.of(context)!.change_password_old,
                    hintText: "**********",
                    type: TextInputType.visiblePassword,
                    onChanged: (v) => oldPassword.value = v,
                    canHide: true,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  BrandedTextfield(
                    labelText:
                        AppLocalizations.of(context)!.change_password_new,
                    hintText: "**********",
                    type: TextInputType.visiblePassword,
                    onChanged: (v) => newPassword.value = v,
                    canHide: true,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  BrandedTextfield(
                    labelText: AppLocalizations.of(context)!
                        .change_password_new_repeat,
                    hintText: "**********",
                    type: TextInputType.visiblePassword,
                    onChanged: (v) => newPasswordRepeat.value = v,
                    canHide: true,
                    textInputAction: TextInputAction.send,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  PasswordValidationIndicator(password: newPassword.value),
                  SizedBox(
                    height: 15,
                  ),
                ],
              )),
              Row(
                children: [
                  Expanded(
                    child: BrandedButton(
                      loading: loading.value,
                      onPressed: handleSubmit,
                      child: Text(
                        AppLocalizations.of(context)!.change_password_save,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
