import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../style/theme.dart';
import '../../widgets/recently_closed_order_card.dart';

class RecentlyClosedSection extends StatelessWidget {
  const RecentlyClosedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.dash_rec_title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                AppLocalizations.of(context)!.dash_view,
                style: NeoTheme.of(context)!.linkTextStyle,
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Column(
            children: [
              RecentlyClosedOrderCard(),
              SizedBox(
                height: 16,
              ),
              RecentlyClosedOrderCard(),
              SizedBox(
                height: 16,
              ),
              RecentlyClosedOrderCard()
            ],
          )
        ],
      ),
    );
  }
}
