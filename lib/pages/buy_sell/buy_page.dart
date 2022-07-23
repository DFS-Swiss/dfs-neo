import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/buy_sell/amount_selector.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/widgets/buttons/branded_button.dart';

import '../../widgets/branded_switch.dart';

class BuyPage extends HookWidget {
  final String symbol;
  const BuyPage({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountInDollar = useRef<double>(0);
    final loading = useState(false);

    hanldeBuy() async {
      if (amountInDollar.value > 0) {
        loading.value = true;
        try {
          await DataService.getInstance()
              .buyAsset(symbol, amountInDollar.value);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                  AppLocalizations.of(context)!.new_order_buy_success_title),
              content: Text(
                "$symbol ${AppLocalizations.of(context)!.new_order_buy_success}",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                )
              ],
            ),
          );
        } catch (e) {
          if (e is DioError &&
              e.response!.data["message"] == "Insuficient funds") {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                    AppLocalizations.of(context)!.new_order_buy_success_error),
                content: Text(AppLocalizations.of(context)!
                    .new_order_buy_success_error_ins_funds),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  )
                ],
              ),
            );
          }
          print(e);
        }
        loading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.share_buy} $symbol"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    AmountSelector(
                      symbol: symbol,
                      callbackDollarAmount: (v) => amountInDollar.value = v,
                    ),
                    SizedBox(
                      height: 29,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.new_order_advanced,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        BrandedSwitch(
                          value: false,
                          onChanged: (v) {},
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: BrandedButton(
                        loading: loading.value,
                        onPressed: hanldeBuy,
                        child: Text(
                          AppLocalizations.of(context)!.new_order_create,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
