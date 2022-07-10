import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:neo/hooks/use_stockdata_info.dart';
import 'package:neo/hooks/use_stockdata_latest_price.dart';
import 'package:shimmer/shimmer.dart';

class AmountSelector extends HookWidget {
  final dollarControler = TextEditingController();
  final assetControler = TextEditingController();
  final String symbol;
  final Function(double) callbackDollarAmount;
  AmountSelector({
    Key? key,
    required this.symbol,
    required this.callbackDollarAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          callback: (value) {
            amountInDollar.value = value;
            final assets = value / latestPrice.data!.price;
            amountInShares.value = assets;
            assetControler.text = assets.toString();
            callbackDollarAmount(value);
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
          callback: (value) {
            amountInShares.value = value;
            final dollar = value * latestPrice.data!.price;
            amountInDollar.value = dollar;
            dollarControler.text = dollar.toString();
            callbackDollarAmount(dollar);
          },
        ),
      ],
    );
  }
}

class TradeAssetInputFieldAsset extends HookWidget {
  final TextEditingController controler;
  final String imageLink;
  final bool loading;
  final Function(double) callback;
  final FocusNode node = FocusNode();
  TradeAssetInputFieldAsset(
      {Key? key,
      required this.imageLink,
      this.loading = false,
      required this.callback,
      required this.controler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !loading
        ? GestureDetector(
            onTap: () => node.requestFocus(),
            child: Container(
              height: 79,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor.withOpacity(0.75),
                border: Border.all(
                  color: Theme.of(context).backgroundColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.new_order_amount,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 24,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Transform.translate(
                                  offset: Offset(0, -12),
                                  child: TextFormField(
                                    focusNode: node,
                                    cursorColor: Theme.of(context).primaryColor,
                                    controller: controler,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          (RegExp("[.0-9]"))),
                                    ],
                                    onChanged: ((value) {
                                      double parsedValue;
                                      if (value == "") {
                                        parsedValue = 0;
                                      } else {
                                        parsedValue = double.parse(value);
                                      }
                                      callback(parsedValue);
                                    }),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: TextStyle(
                                      color: Color(0xFF202532),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
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
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(0xFF0B223D),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(imageLink),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    AppLocalizations.of(context)!.new_order_shares,
                    style: TextStyle(
                      color: Color(0xFF202532),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          )
        : Shimmer.fromColors(
            baseColor: Color.fromRGBO(238, 238, 238, 0.75),
            highlightColor: Colors.white,
            child: Container(
              height: 79,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
          );
  }
}

class TradeAssetInputFieldDollar extends HookWidget {
  final TextEditingController controller;
  final bool loading;
  final Function(double) callback;
  final FocusNode node = FocusNode();

  TradeAssetInputFieldDollar({
    Key? key,
    this.loading = false,
    required this.controller,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !loading
        ? GestureDetector(
            onTap: () => node.requestFocus(),
            child: Container(
              height: 79,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor.withOpacity(0.75),
                border: Border.all(
                  color: Theme.of(context).backgroundColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.new_order_price,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 24,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller.text != ""
                                  ? Text(
                                      "\$",
                                      style: TextStyle(
                                        color: Color(0xFF202532),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Transform.translate(
                                  offset: Offset(0, -12),
                                  child: TextFormField(
                                    focusNode: node,
                                    cursorColor: Theme.of(context).primaryColor,
                                    controller: controller,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          (RegExp("[.0-9]"))),
                                    ],
                                    onChanged: ((value) {
                                      double parsedValue;
                                      if (value == "") {
                                        parsedValue = 0;
                                      } else {
                                        parsedValue = double.parse(value);
                                      }
                                      callback(parsedValue);
                                    }),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: TextStyle(
                                      color: Color(0xFF202532),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
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
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(0xFF0B223D),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.attach_money,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "USD",
                    style: TextStyle(
                      color: Color(0xFF202532),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          )
        : Shimmer.fromColors(
            baseColor: Color.fromRGBO(238, 238, 238, 0.75),
            highlightColor: Colors.white,
            child: Container(
              height: 79,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
          );
  }
}
