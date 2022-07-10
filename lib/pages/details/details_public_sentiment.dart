import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/widgets/public_sentiment_widget.dart';

class DetailsPublicSentiment extends HookWidget {
  final String symbol;
  const DetailsPublicSentiment({required this.symbol, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.details_public_sentiment,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                AppLocalizations.of(context)!.details_last_week_sentiment,
                style: NeoTheme.of(context)!.linkTextStyle,
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          PublicSentiment(percentage: 10)
        ],
      ),
    );
  }
}
