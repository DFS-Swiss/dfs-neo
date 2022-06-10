import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/utils/password_validator.dart';
import 'package:neo/widgets/branded_button.dart';
import 'package:neo/widgets/branded_textfield.dart';
import 'package:neo/widgets/password_validation_indicator.dart';

class NewPasswordRequired extends HookWidget {
  const NewPasswordRequired({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final password = useState<String?>(null);
    final loading = useState(false);
    final error = useState<String?>(null);

    handleSubmit() async {
      error.value = null;
      if (password.value != null &&
          PasswordValidator.isPasswordValid(password.value!)) {
        loading.value = true;
        try {
          await AuthenticationService.getInstance()
              .completeForceChangePassword(password.value!);
        } catch (e) {
          print(e);
          error.value = AppLocalizations.of(context)!.error_generic;
        }
        loading.value = false;
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.force_change_password_title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        AppLocalizations.of(context)!.force_change_password_desc,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      SizedBox(
        height: 20,
      ),
      BrandedTextfield(
        labelText: AppLocalizations.of(context)!.force_change_password_label,
        hintText: "**********",
        canHide: true,
        type: TextInputType.visiblePassword,
        onChanged: (v) => password.value = v,
        errorText: error.value,
      ),
      SizedBox(
        height: 15,
      ),
      PasswordValidationIndicator(password: password.value),
      SizedBox(
        height: 25,
      ),
      Row(
        children: [
          Expanded(
            child: BrandedButton(
              text: AppLocalizations.of(context)!.force_change_password_submit,
              onPressed: handleSubmit,
            ),
          )
        ],
      )
    ]);
  }
}
