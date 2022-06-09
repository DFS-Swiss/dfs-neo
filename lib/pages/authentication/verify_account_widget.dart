import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/style/theme.dart';

import '../../widgets/branded_button.dart';
import '../../widgets/branded_textfield.dart';

class VerifyAccountWidget extends HookWidget {
  const VerifyAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final code = useState<String?>(null);
    final loading = useState(false);
    final error = useState<String?>(null);

    handleSubmit() async {
      if (code.value != null) {
        loading.value = true;
        try {
          await AuthenticationService.getInstance().confirmEmail(code.value!);
        } catch (e) {
          error.value = AppLocalizations.of(context)!.error_generic;
        }
        loading.value = false;
      }
    }

    handleResend() async {
      loading.value = true;
      await AuthenticationService.getInstance().resendConfirmationCode();
      loading.value = false;
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.verify_account_title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        AppLocalizations.of(context)!.verify_account_desc,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      SizedBox(
        height: 20,
      ),
      BrandedTextfield(
        labelText: AppLocalizations.of(context)!.verify_account_label,
        hintText: AppLocalizations.of(context)!.verify_account_hint,
        type: TextInputType.text,
        onChanged: (v) => code.value = v,
        errorText: error.value,
      ),
      SizedBox(
        height: 10,
      ),
      GestureDetector(
        onTap: handleResend,
        child: Text(
          AppLocalizations.of(context)!.verify_account_resend_code,
          style: NeoTheme.of(context)!.linkTextStyle,
        ),
      ),
      SizedBox(
        height: 25,
      ),
      Row(
        children: [
          Expanded(
            child: BrandedButton(
              text: AppLocalizations.of(context)!.verify_account_submit,
              onPressed: handleSubmit,
            ),
          )
        ],
      ),
    ]);
  }
}
