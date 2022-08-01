import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:neo/hooks/use_stockdata_info.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/style/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecentlyClosedOrderCard extends HookWidget {
  final UserassetDatapoint data;
  const RecentlyClosedOrderCard({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Improve the recently closed orders UI
    final assetData = useSymbolInfo(data.symbol);
    final f = DateFormat('HH:MM dd.MM.yyyy');
    return assetData.loading
        ? Container()
        : Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Container(
                  height: 130,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 38,
                            height: 38,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(assetData.data!.imageUrl),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                assetData.data!.symbol,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                assetData.data!.displayName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF909090),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          Expanded(child: Container()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                data.difference.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: data.difference > 0
                                      ? NeoTheme.of(context)!.positiveColor
                                      : NeoTheme.of(context)!.negativeColor,
                                ),
                              ),
                              Text(
                                f.format(data.time),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF909090),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.dash_rec_type,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                    data.difference > 0
                                        ? AppLocalizations.of(context)!
                                            .dash_rec_type_buy
                                        : AppLocalizations.of(context)!
                                            .dash_rec_type_sell,
                                    style:
                                        Theme.of(context).textTheme.labelMedium)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.dash_rec_entry,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                    "d\$ ${data.currentValue.toStringAsFixed(2)}",
                                    style:
                                        Theme.of(context).textTheme.labelMedium)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.dash_rec_pl,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Coming soon",
                                    style:
                                        Theme.of(context).textTheme.labelMedium)
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Positioned.fill(
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(12),
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              //       child: Center(
              //         child: Text(AppLocalizations.of(context)!.order_coming_soon),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
  }
}
