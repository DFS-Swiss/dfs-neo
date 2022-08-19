import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:neo/hooks/use_stockdata_info.dart';
import 'package:neo/hooks/use_stockdata_latest_price.dart';
import 'package:neo/pages/buy_sell/trade_asset_input_field_asset.dart';
import 'package:neo/pages/buy_sell/trade_asset_input_field_dollar.dart';
import 'package:neo/utils/formatting_utils.dart';

class AmountSelector extends HookWidget {
  final String symbol;
  final Function(double)? callbackDollarAmount;
  final Function(double)? callbackTokenAmount;
  final bool buyMode;

  const AmountSelector({
    Key? key,
    required this.symbol,
    required this.buyMode,
    this.callbackDollarAmount,
    this.callbackTokenAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dollarControler = useTextEditingController();
    final assetControler = useTextEditingController();
    final info = useSymbolInfo(symbol);
    final latestPrice = useLatestPrice(symbol);

    final amountInDollar = useState<double>(0);
    final amountInShares = useState<double>(0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TradeAssetInputFieldDollar(
          loading: info.loading,
          controller: dollarControler,
          showPercentageSlider: buyMode,
          callback: (value) {
            amountInDollar.value = value;
            final assets = FormattingUtils.roundDouble(
                value / latestPrice.data!.price, 3);
            amountInShares.value = assets;
            assetControler.text = assets.toString();
            dollarControler.text = value.toString();
            if (callbackDollarAmount != null) {
              callbackDollarAmount!(value);
            }
            if (callbackTokenAmount != null) {
              callbackTokenAmount!(assets);
            }
          },
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Positioned.fill(child: Divider()),
                  Positioned(
                    left: 16,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Color(0xFFC2C8CE), width: 1),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.sync,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
              SizedBox(width: 12),
              Text(
                "${AppLocalizations.of(context)!.new_order_price_per_share} = ${latestPrice.loading ? "..." : NumberFormat.currency().format(latestPrice.data!.price)}",
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TradeAssetInputFieldAsset(
          imageLink: info.data?.imageUrl ?? "",
          loading: info.loading,
          controler: assetControler,
          showPercentageSlider: !buyMode,
          symbol: symbol,
          callback: (value) {
            amountInShares.value = value;
            final dollar = FormattingUtils.roundDouble(
              value * latestPrice.data!.price,
              3,
            );
            amountInDollar.value = dollar;
            dollarControler.text = dollar.toString();
            assetControler.text = value.toString();
            if (callbackDollarAmount != null) {
              callbackDollarAmount!(dollar);
            }
            if (callbackTokenAmount != null) {
              callbackTokenAmount!(value);
            }
          },
        ),
      ],
    );
  }
}
