import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image/network.dart';
import 'package:neo/hooks/use_user_assets_for_symbol.dart';
import 'package:neo/services/formatting_service.dart';

import '../../widgets/shimmer_loader_card.dart';

class TradeAssetInputFieldAsset extends HookWidget {
  final TextEditingController controler;
  final String imageLink;
  final bool loading;
  final Function(double) callback;
  final FocusNode node = FocusNode();
  final String symbol;
  final bool showPercentageSlider;

  TradeAssetInputFieldAsset(
      {Key? key,
      required this.imageLink,
      this.loading = false,
      required this.callback,
      required this.controler,
      required this.symbol,
      this.showPercentageSlider = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avaliableAssets = useUserAssetsForSymbol(symbol);
    final percentage = useState<double>(0);

    useEffect(() {
      listener() {
        final value = double.tryParse(controler.text);
        if (value != null) {
          percentage.value = value;
        }
      }

      controler.addListener(listener);
      return () => controler.removeListener(listener);
    }, ["_"]);

    return !loading && !avaliableAssets.loading
        ? GestureDetector(
            onTap: () => node.requestFocus(),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor.withOpacity(0.75),
                border: Border.all(
                  color: Theme.of(context).backgroundColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
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
                                        focusNode:
                                            Platform.isAndroid ? null : node,
                                        cursorColor:
                                            Theme.of(context).primaryColor,
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
                                            parsedValue =
                                                double.tryParse(value) ?? 0;
                                          }
                                          callback(parsedValue);
                                        }),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .color,
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
                          key: ValueKey(imageLink),
                          backgroundImage: NetworkImageWithRetry(imageLink),
                          backgroundColor: Theme.of(context).backgroundColor,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        AppLocalizations.of(context)!.new_order_shares,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.labelSmall!.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  showPercentageSlider
                      ? SizedBox(
                          height: 20,
                        )
                      : Container(),
                  showPercentageSlider
                      ? Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: (percentage.value /
                                        avaliableAssets.data!.quantity)
                                    .clamp(0, 1),
                                label:
                                    "${(percentage.value / avaliableAssets.data!.quantity * 100).toStringAsFixed(0)}%",
                                min: 0,
                                max: 1,
                                divisions: 4,
                                onChanged: (v) {
                                  callback(FormattingService.roundDouble(
                                      avaliableAssets.data!.quantity * v, 3));
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${FormattingService.roundDouble(avaliableAssets.data!.quantity, 2).toString()} ${AppLocalizations.of(context)!.new_order_avaliable}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .color,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          )
        : ShimmerLoadingCard(height: 79);
  }
}
