import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/style/theme.dart';

class DetailsAboutSection extends HookWidget {
  final String symbol;
  const DetailsAboutSection({required this.symbol, Key? key}) : super(key: key);

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
                AppLocalizations.of(context)!.details_about,
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
          Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sodales aliquam condimentum. Cras non est lectus. Aliquam leo justo, vestibulum non porta in, consequat aliquam nisi. Mauris pulvinar ex egestas, faucibus lacus non, malesuada leo. Nam fermentum malesuada nibh."),
        ],
      ),
    );
  }
}
