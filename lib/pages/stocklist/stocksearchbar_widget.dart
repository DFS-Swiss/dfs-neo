import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StockSearchBar extends HookWidget {
  const StockSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Container(
        alignment: Alignment.center,
        height: 48,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(12)),
        child: TextFormField(
          cursorColor: Theme.of(context).primaryColor,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            iconColor: Color(0xFF909090),
            focusColor: Color(0xFF909090),
            hintText: AppLocalizations.of(context)!.list_search,
            hintStyle: TextStyle(
              color: Color(0xFF909090),
              fontSize: 16,
            ),
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
