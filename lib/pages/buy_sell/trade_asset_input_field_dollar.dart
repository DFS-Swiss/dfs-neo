import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/hooks/use_balance.dart';
import 'package:neo/hooks/use_brightness.dart';

import '../../services/formatting_service.dart';
import '../../widgets/shimmer_loader_card.dart';

class TradeAssetInputFieldDollar extends HookWidget {
  final TextEditingController controller;
  final bool loading;
  final Function(double) callback;
  final FocusNode node = FocusNode();
  final bool showPercentageSlider;

  TradeAssetInputFieldDollar(
      {Key? key,
      this.loading = false,
      required this.controller,
      required this.callback,
      this.showPercentageSlider = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = useState<double>(0);
    final balance = useBalance();
    final brightness = useBrightness();

    useEffect(() {
      listener() {
        final value = double.tryParse(controller.text);
        if (value != null) {
          percentage.value = value;
        }
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, ["_"]);

    return !loading && !balance.loading
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
                                            color: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .color,
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
                                        autofocus: true,
                                        focusNode:
                                            Platform.isAndroid ? null : node,
                                        cursorColor:
                                            Theme.of(context).primaryColor,
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
                        child: Center(
                          child: Icon(
                            Icons.attach_money,
                            color: brightness ==
                                    Brightness.dark
                                ? Theme.of(context).iconTheme.color
                                : Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "USD",
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
                                        balance.data!.newBalance)
                                    .clamp(0, 1),
                                label:
                                    "${(percentage.value / balance.data!.newBalance * 100).toStringAsFixed(0)}%",
                                min: 0,
                                max: 1,
                                divisions: 4,
                                onChanged: (v) {
                                  var value = FormattingService.roundDouble(
                                      balance.data!.newBalance * v, 3);
                                  controller.text = value.toString();
                                  callback(value);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${FormattingService.roundDouble(balance.data!.newBalance, 2).toString()}\$ ${AppLocalizations.of(context)!.new_order_avaliable}",
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
        : ShimmerLoadingCard(height: 83);
  }
}
