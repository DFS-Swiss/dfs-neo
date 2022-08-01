import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import '../models/userasset_datapoint.dart';
import '../types/data_container.dart';
import '../types/user_asset_datapoint_with_value.dart';

DataContainer<List<UserAssetDataWithValue>> useUserAssetsWithValues() {
  final state = useState<DataContainer<List<UserAssetDataWithValue>>>(
      DataContainer.waiting());

  fetch() async {
    final out = <UserAssetDataWithValue>[];
    final investments = DataService.getInstance()
            .getDataFromCacheIfAvaliable<List<UserassetDatapoint>>(
                "investments") ??
        await DataService.getInstance().getUserAssets().first;
    for (var investment in investments) {
      final price = await StockdataService.getInstance()
          .getLatestPrice(investment.symbol)
          .first;
      out.add(UserAssetDataWithValue.fromUserAssetDataPoint(
          investment, investment.tokenAmmount * price.price));
    }
    out.sort((a, b) => b.totalValue.compareTo(a.totalValue));
    state.value = DataContainer(data: out);
  }

  useEffect(() {
    fetch();
    final sub =
        DataService.getInstance().getUserAssets().listen((v) => fetch());
    StockdataService.getInstance().addListener(fetch);
    return () {
      sub.cancel();
      StockdataService.getInstance().removeListener(fetch);
    };
  }, ["_"]);
  return state.value;
}
