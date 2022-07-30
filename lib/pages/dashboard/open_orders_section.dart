import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/utils/display_popup.dart';
import 'package:neo/widgets/cards/open_order_card.dart';

class OpenOrdersSection extends HookWidget {
  const OpenOrdersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constroller = usePageController(viewportFraction: 1.1);
    final page = useState(0);
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.dash_oo,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                GestureDetector(
                  onTap: () {
                    displayPopup(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.dash_view,
                    style: NeoTheme.of(context)!.linkTextStyle,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 170,
            child: PageView(
              controller: constroller,
              onPageChanged: (newPage) => page.value = newPage,
              children: [OpenOrderCard(), OpenOrderCard(), OpenOrderCard()],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: page.value == 0
                      ? Theme.of(context).primaryColor
                      : Color.fromRGBO(187, 187, 187, 1),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: page.value == 1
                      ? Theme.of(context).primaryColor
                      : Color.fromRGBO(187, 187, 187, 1),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: page.value == 2
                      ? Theme.of(context).primaryColor
                      : Color.fromRGBO(187, 187, 187, 1),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
