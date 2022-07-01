import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/deposit/moneyselectable_widget.dart';
import 'package:neo/widgets/textfield/money_textfield.dart';

import '../../widgets/appbaractionbutton_widget.dart';
import '../../widgets/branded_button.dart';

class Deposit extends HookWidget {
  const Deposit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedAmount = useState<String>("");
    final typedAmount = useState<String>("");

    var depositAmount =
        typedAmount.value.isEmpty ? selectedAmount.value : typedAmount.value;

    handleNext() {}

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.port_deposit),
        leading: Padding(
          padding: EdgeInsets.fromLTRB(16,0,0,0),
          child: AppBarActionButton(
            icon: Icons.arrow_back_outlined,
            callback: () {
              Navigator.of(context).pop(null);
            },
          ),
        ),
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              MoneyTextfield(
                ValueKey("\$"),
                hintText:
                    AppLocalizations.of(context)!.deposit_enter_deposit_amount,
                labelText: depositAmount,
                onChanged: (String value) {
                  selectedAmount.value = "";
                  typedAmount.value = value;
                },
              ),
              MoneySelectable(
                callback: (String amount) {
                  selectedAmount.value = amount;
                },
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
                      child: Text(AppLocalizations.of(context)!
                          .deposit_continue_button),
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
