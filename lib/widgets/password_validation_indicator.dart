import 'package:flutter/material.dart';
import 'package:neo/widgets/custom_checkmark.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/password_validator.dart';

class PasswordValidationIndicator extends StatelessWidget {
  final String? password;
  const PasswordValidationIndicator({Key? key, required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCheckmark(
          state: password == null
              ? CheckmarkState.unknown
              : PasswordValidator.is8Characters(password!)
                  ? CheckmarkState.ok
                  : CheckmarkState.error,
          label: AppLocalizations.of(context)!.password_at_least_8_chars,
        ),
        CustomCheckmark(
          state: password == null
              ? CheckmarkState.unknown
              : PasswordValidator.containsNumber(password!)
                  ? CheckmarkState.ok
                  : CheckmarkState.error,
          label: AppLocalizations.of(context)!.password_digit_characters,
        ),
        CustomCheckmark(
          state: password == null
              ? CheckmarkState.unknown
              : PasswordValidator.containsSpecialCharacter(password!)
                  ? CheckmarkState.ok
                  : CheckmarkState.error,
          label: AppLocalizations.of(context)!.password_special_characters,
        ),
        CustomCheckmark(
          state: password == null
              ? CheckmarkState.unknown
              : PasswordValidator.containsUpperCaseCharacter(password!)
                  ? CheckmarkState.ok
                  : CheckmarkState.error,
          label: AppLocalizations.of(context)!.password_upper_characters,
        ),
        CustomCheckmark(
          state: password == null
              ? CheckmarkState.unknown
              : PasswordValidator.containsLowerCaseCharacter(password!)
                  ? CheckmarkState.ok
                  : CheckmarkState.error,
          label: AppLocalizations.of(context)!.password_lower_characters,
        ),
      ],
    );
  }
}
