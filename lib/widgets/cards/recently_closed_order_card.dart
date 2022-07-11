import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neo/style/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecentlyClosedOrderCard extends StatelessWidget {
  const RecentlyClosedOrderCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                      backgroundImage: NetworkImage(
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
                  Text(
                    "+262.06USD",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: NeoTheme.of(context)!.positiveColor,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dash_rec_type,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("Long",
                          style: Theme.of(context).textTheme.labelMedium)
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dash_rec_entry,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("\$186.84",
                          style: Theme.of(context).textTheme.labelMedium)
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dash_rec_pl,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("\$376.10",
                          style: Theme.of(context).textTheme.labelMedium)
                    ],
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
    );
  }
}
