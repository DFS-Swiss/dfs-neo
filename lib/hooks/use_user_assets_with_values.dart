import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import '../models/userasset_datapoint.dart';
import '../service_locator.dart';
import '../types/data_container.dart';
import '../types/user_asset_datapoint_with_value.dart';

DataContainer<List<UserAssetDataWithValue>> useUserAssetsWithValues() {
  final DataService dataService = locator<DataService>();
  final StockdataService stockdataService = locator<StockdataService>();
  final state = useState<DataContainer<List<UserAssetDataWithValue>>>(
      DataContainer.waiting());

  fetch() async {
    final out = <UserAssetDataWithValue>[];
    final investments =
        dataService.getDataFromCacheIfAvaliable<List<UserassetDatapoint>>(
                "investments") ??
            await dataService.getUserAssets().first;
    for (var investment in investments) {
      final price = await stockdataService
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
    final sub = dataService.getUserAssets().listen((v) => fetch());
    stockdataService.addListener(fetch);
    return () {
      sub.cancel();
      stockdataService.removeListener(fetch);
    };
  }, ["_"]);
  return state.value;
}
