import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neo/widgets/development_indicator/small_change_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OpenOrderCard extends StatelessWidget {
  final String? image;
  const OpenOrderCard({this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          image ??
                              "https://prod-dfs-swiss-dfssymboliconbucketd59bac7b-la02u10dfrul.s3.eu-central-1.amazonaws.com/AMZN.png",
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "dAMZN",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Amazon",
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
                    SmallDevelopmentIndicator(
                        positive: true, changePercentage: 0.21),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xFF909090).withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.dash_oo_buy,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dash_oo_amount,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      "3 ${AppLocalizations.of(context)!.dash_oo_amount_short}",
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dash_oo_buyat,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      "\$90 ${AppLocalizations.of(context)!.dash_oo_amount_short}",
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dash_oo_current,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      "\$100 ${AppLocalizations.of(context)!.dash_oo_amount_short}",
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Center(
                  child: Text(AppLocalizations.of(context)!.order_coming_soon),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
