import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsAboutSection extends HookWidget {
  final String symbol;
  final String description;
  const DetailsAboutSection(
      {required this.symbol, required this.description, Key? key})
      : super(key: key);

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
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            description,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
