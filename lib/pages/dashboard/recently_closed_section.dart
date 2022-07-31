import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:neo/hooks/use_userassets_history.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/types/data_container.dart';

import 'package:neo/utils/display_popup.dart';

import '../../style/theme.dart';
import '../../widgets/cards/recently_closed_order_card.dart';

class RecentlyClosedSection extends HookWidget {
  const RecentlyClosedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final investmenthistory = useUserassetsHistory();
    final tempList = useState<DataContainer<List<UserassetDatapoint>>>(
        DataContainer.waiting());

    useEffect(() {
      if (!investmenthistory.loading && investmenthistory.data != null) {
        investmenthistory.data!.sort(((a, b) => b.time.compareTo(a.time)));
        tempList.value =
            DataContainer(data: investmenthistory.data, loading: false);
      }
      return;
    }, [investmenthistory.loading, investmenthistory.data]);
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
                  AppLocalizations.of(context)!.dash_rec_title,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: !tempList.value.loading
                  ? tempList.value.data!
                      .take(3)
                      .map((e) => RecentlyClosedOrderCard(
                            data: e,
                            key: Key(e.symbol+e.time.millisecondsSinceEpoch.toString()),
                          ))
                      .toList()
                  : [
                      Container(),
                    ],
            ),
          )
        ],
      ),
    );
  }
}
