import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StockSearchBar extends HookWidget {
  final Function callback;
  final int? customPadding;
  const StockSearchBar( {this.customPadding = 0,
    required this.callback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    return Padding(
      padding: customPadding != 0 ? const EdgeInsets.only(left: 24, top: 20, right: 24) : const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Container(
        alignment: Alignment.center,
        //height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor.withOpacity(0.75),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextFormField(
          controller: searchController,
          onChanged: (a) {
            callback(a);
          },
          cursorColor: Theme.of(context).primaryColor,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: false,
            suffixIcon: searchController.text == ""
                ? Icon(
                    Icons.cancel,
                    size:
                        0, //This is nesessarcy! The icon must not be display, but if it is changed to a container the textfield hint text disappears!
                  )
                : GestureDetector(
                    onTap: () {
                      callback("");
                      searchController.text = "";
                    },
                    child: Icon(Icons.cancel)),
            iconColor: Color(0xFF909090),
            focusColor: Color(0xFF909090),
            hintText: AppLocalizations.of(context)!.list_search,
            hintStyle: TextStyle(
              color: Color(0xFF909090),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFF909090),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
