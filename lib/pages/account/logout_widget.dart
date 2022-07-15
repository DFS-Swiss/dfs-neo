import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/authentication/auth_page_wrapper.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/cognito_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogoutTextButton extends HookWidget {
  const LogoutTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () {
              try {
                locator<AuthenticationService>().logOut();
                //TODO: Add logout
              } catch (e) {
                print(e);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.logout_outlined,
                  color: Color(0xFFF33556),
                ),
                Text(
                  AppLocalizations.of(context)!.account_logout,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Color(0xFFF33556),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
