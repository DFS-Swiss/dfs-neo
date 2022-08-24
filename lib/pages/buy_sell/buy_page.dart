import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/buy_sell/amount_selector.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/widgets/dialogs/custom_dialog.dart';
import 'package:neo/utils/display_popup.dart';
import '../../service_locator.dart';
import '../../services/analytics_service.dart';
import '../../widgets/branded_switch.dart';
import '../../widgets/buttons/branded_button.dart';

class BuyPage extends HookWidget {
  final String symbol;
  const BuyPage({Key? key, required this.symbol}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final DataService dataService = locator<DataService>();
    final amountInDollar = useRef<double>(0);
    final loading = useState(false);
    useEffect(() {
      locator<AnalyticsService>().trackEvent(
        "display:buy_asset",
        eventProperties: {
          "asset": symbol,
        },
      );
      return;
    }, ["_"]);

    hanldeBuy() async {
      if (!loading.value) {
        if (amountInDollar.value > 0) {
          loading.value = true;
          try {
            await dataService.buyAsset(symbol, amountInDollar.value);
            locator<AnalyticsService>().trackEvent(
              "action:buy",
              eventProperties: {
                "asset": symbol,
              },
            );
            showDialog(
              context: context,
              builder: (context) => CustomDialog(
                title:
                    AppLocalizations.of(context)!.new_order_buy_success_title,
                message:
                    "$symbol ${AppLocalizations.of(context)!.new_order_buy_success}",
                callback: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            );
          } catch (e) {
            if (e is DioError &&
                e.response!.data["message"] == "Insuficient funds") {
              showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  title:
                      AppLocalizations.of(context)!.new_order_buy_success_error,
                  message: AppLocalizations.of(context)!
                      .new_order_buy_success_error_ins_funds,
                  callback: () => Navigator.pop(context),
                ),
              );
            }
          }
          loading.value = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.share_buy} $symbol"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
            ),
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
                      key: ValueKey(symbol),
                      buyMode: true,
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
                          onChanged: (v) {
                            displayPopup(context);
                          },
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
