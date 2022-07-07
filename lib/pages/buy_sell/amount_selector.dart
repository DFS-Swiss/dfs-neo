import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AmountSelector extends HookWidget {
  const AmountSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountInDollar = useState(0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 74,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor.withOpacity(0.75),
            border: Border.all(
              color: Theme.of(context).backgroundColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.new_order_price,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 24,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixText: "\$",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF202532),
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
