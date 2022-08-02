import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/shimmer_loader_card.dart';

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
              height: 83,
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
                                    focusNode: Platform.isAndroid ? null : node,
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
                      backgroundImage: NetworkImage(imageLink),
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
            ),
          )
        : ShimmerLoadingCard(height: 79);
  }
}
