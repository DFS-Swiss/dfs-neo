import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/global_settings_service.dart';

import '../hooks/use_balance_hidden.dart';

class HideBalanceButton extends HookWidget {
  const HideBalanceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hideBalance = useBalanceHidden();
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () =>
          GlobalSettingsService.getInstance().hideBalance = !hideBalance,
      icon: Icon(hideBalance ? Icons.visibility : Icons.visibility_off),
    );
  }
}
