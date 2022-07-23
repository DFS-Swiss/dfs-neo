import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/branded_button.dart';
import '../../widgets/branded_textfield.dart';

class ForgotPassword extends HookWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = useState<String?>(null);
    final error = useState<String?>(null);

    handleSubmit() {}

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
        onChanged: (v) => userName.value = v,
        labelText: AppLocalizations.of(context)!.signin_username,
        hintText: AppLocalizations.of(context)!.signin_username_desc,
        type: TextInputType.emailAddress,
        errorText: error.value,
        textInputAction: TextInputAction.next,
      ),
      SizedBox(
        height: 25,
      ),
      Row(
        children: [
          Expanded(
            child: BrandedButton(
              onPressed: handleSubmit,
              child: Text(
                AppLocalizations.of(context)!.forgot_password_continue,
              ),
            ),
          )
        ],
      )
    ]);
  }
}
