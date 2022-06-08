import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/widgets/branded_button.dart';

import '../../widgets/branded_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginWidget extends HookWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = useState<String?>(null);
    final password = useState<String?>(null);
    final loading = useState(false);

    return Column(
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
          hintText: "Type in your Username",
          type: TextInputType.emailAddress,
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
                text: "Sign in",
                loading: loading.value,
                onPressed: userName.value != null && password.value != null
                    ? () async {
                        loading.value = true;
                        try {
                          await AuthenticationService.getInstance()
                              .login(userName.value!, password.value!);
                        } catch (e) {
                          print(e);
                        }
                        loading.value = false;
                      }
                    : null,
              ),
            ),
          ],
        )
      ],
    );
  }
}
