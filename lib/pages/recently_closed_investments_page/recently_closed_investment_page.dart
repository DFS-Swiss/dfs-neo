import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/hooks/use_userassets_history.dart';
import 'package:neo/models/userasset_datapoint.dart';
import 'package:neo/types/data_container.dart';
import 'package:neo/widgets/cards/dynamic_shimmer_cards.dart';
import 'package:neo/widgets/cards/recently_closed_order_card.dart';

class RecentlyClosedInvestments extends HookWidget {
  final String? exclusiveSymbol;
  const RecentlyClosedInvestments( {this.exclusiveSymbol,Key? key}) : super(key: key);

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
    }, [investmenthistory.loading, investmenthistory.data, key]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.dash_rec_title,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: !tempList.value.loading && tempList.value.data != null
              ? ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => RecentlyClosedOrderCard(
                      data: tempList.value.data!.elementAt(index)),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: tempList.value.data!.length)
              : !tempList.value.loading
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.util_no_data,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    )
                  : DynamicShimmerCards(
                      cardAmount: 3,
                      cardHeight: 130,
                      bottomPadding: 16,
                      sidePadding: 20)),
    );
  }
}
