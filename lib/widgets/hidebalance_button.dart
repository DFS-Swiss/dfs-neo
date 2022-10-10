import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../hooks/use_balance_hidden.dart';
import '../service_locator.dart';
import '../services/settings/settings_service.dart';

class HideBalanceButton extends HookWidget {
  const HideBalanceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hideBalance = useBalanceHidden();
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
          onTap: () => locator<SettingsService>()
              .hideBalanceSettings
              .setValue(!hideBalance),
          child: Icon(hideBalance ? Icons.visibility : Icons.visibility_off)),
    );
  }
}
