import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/widgets/textfield/money_textfield.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/branded_button.dart';

class Deposit extends HookWidget {
  const Deposit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    handleNext() {}

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.port_deposit),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              MoneyTextfield(
                ValueKey("\$"),
                hintText: 'Enter deposit amount (10 - 50.000\$)',
                labelText: '',
                onChanged: (String value) {},
              ),
              Expanded(
                child: SizedBox(),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: BrandedButton(
                      onPressed: handleNext,
                      child: Text(AppLocalizations.of(context)!.signin_button),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
