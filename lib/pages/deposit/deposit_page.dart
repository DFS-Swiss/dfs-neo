import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:neo/pages/deposit/moneyselectable_widget.dart';
import 'package:neo/widgets/textfield/money_textfield.dart';

import '../../services/data_service.dart';
import '../../widgets/buttons/branded_button.dart';

class Deposit extends HookWidget {
  const Deposit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedAmount = useState<String>("");
    final typedAmount = useState<String>("");

    var depositAmount =
        typedAmount.value.isEmpty ? selectedAmount.value : typedAmount.value;

    // Focus node 
    // Padding beneath button

    handleDeposit() async {
      try {
        if (await DataService.getInstance().addUserBalance(depositAmount)) {
          // Show alert, pop page
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.alert_amount_deposited),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (response) {
        if ((response as dynamic).response.statusCode == 401) {
          // Show alert, pop page
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.alert_amount_limit),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if((response as dynamic).response.statusCode == 400){
           await showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.alert_deposit_limit),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.port_deposit),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        foregroundColor: Colors.black,
      ),
      body: Column(
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
                  typedAmount.value = "";
                },
                currentValue: selectedAmount.value,
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
                    child: SafeArea(
                      child: BrandedButton(
                        onPressed: handleDeposit,
                        child: Text(AppLocalizations.of(context)!
                            .port_deposit),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
