import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:neo/pages/deposit/moneyselectable_widget.dart';
import 'package:neo/widgets/dialogs/custom_dialog.dart';
import 'package:neo/widgets/textfield/money_textfield.dart';

import '../../service_locator.dart';
import '../../services/analytics_service.dart';
import '../../services/data/data_service.dart';
import '../../widgets/buttons/branded_button.dart';

class Deposit extends HookWidget {
  const Deposit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataService dataService = locator<DataService>();
    final selectedAmount = useState<String>("");
    final typedAmount = useState<String>("");
    final loading = useState(false);

    var depositAmount =
        typedAmount.value.isEmpty ? selectedAmount.value : typedAmount.value;

    // Focus node
    // Padding beneath button

    useEffect(() {
      locator<AnalyticsService>().trackEvent("display:debug_deposit");
      return;
    }, ["_"]);

    handleDeposit() async {
      if (!loading.value) {
        loading.value = true;
        try {
          if (await dataService.addUserBalance(depositAmount)) {
            // Show alert, pop page
            locator<AnalyticsService>().trackEvent(
              "action:debug_deposit",
              eventProperties: {
                "amount": depositAmount,
              },
            );
            await showDialog<String>(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                    title: AppLocalizations.of(context)!.alert_amount_deposited,
                    message: "",
                    callback: () {
                      Navigator.pop(context, 'OK');
                      Navigator.pop(context, 'OK');
                    }));
          }
        } catch (response) {
          if ((response as dynamic).response.statusCode == 401) {
            // Show alert, pop page
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                title: AppLocalizations.of(context)!.alert_amount_limit,
                callback: () => Navigator.pop(context, 'OK'),
              ),
            );
          } else if ((response as dynamic).response.statusCode == 400) {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                title: AppLocalizations.of(context)!.alert_deposit_limit,
                callback: () => Navigator.pop(context, 'OK'),
              ),
            );
          }
        }
        loading.value = false;
      }
    }

    bool vailidateAmount() {
      int? temp;
      try {
        if (typedAmount.value == "" && selectedAmount.value != "") {
          temp = int.tryParse(selectedAmount.value);
        } else {
          temp = int.tryParse(typedAmount.value);
        }

        if (temp! >= 10 && temp <= 10000) {
          return true;
        }
      } catch (e) {
        return false;
      }

      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.port_deposit),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
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
                    enabeled: vailidateAmount(),
                    loading: loading.value,
                    onPressed: handleDeposit,
                    child: Text(AppLocalizations.of(context)!.port_deposit),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
