import 'package:neo/models/stockdatadocument.dart';
import 'package:neo/models/userasset_datapoint.dart';

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <Id>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension InlineSort<E> on List<E> {
  List<E> inlineSort([int Function(E, E)? compare]) {
    var list = this;
    list.sort(compare);
    return list;
  }

  List<StockdataDocument> advancedAssetlistSort(int state) {
    List<StockdataDocument> list = this as List<StockdataDocument>;
    if (state == 1) {
      //Sort list by Stocksymbol alphabetically A-Z
      list.sort((a, b) {
        return a.toString().toLowerCase().compareTo(b.toString().toLowerCase());
      });
    } else if (state == 2) {
      //Sort list by Stocksymbol alphabetically Z-A
      list.sort((a, b) {
        return b.toString().toLowerCase().compareTo(a.toString().toLowerCase());
      });
    } else if (state == 3) {
      //Sort list by 24h growth ascending
      //TODO: Implement sort by growth
    } else if (state == 4) {
      //Sort list by 24h growth descending
      //TODO: Implement sort by growth
    }
    print(list);
    return list;
  }

  List<UserassetDatapoint> userAssetlistSort(int state) {
    List<UserassetDatapoint> list = this as List<UserassetDatapoint>;
    if (state == 1) {
      //Sort list by Stocksymbol alphabetically A-Z
      list.sort((a, b) {
        return a.symbol.toLowerCase().compareTo(b.symbol.toLowerCase());
      });
    } else if (state == 2) {
      //Sort list by Stocksymbol alphabetically Z-A
      list.sort((a, b) {
        return b.symbol.toLowerCase().compareTo(a.symbol.toLowerCase());
      });
    } else if (state == 3) {
      //Sort list by 24h growth ascending
      //TODO: Implement sort by growth
    } else if (state == 4) {
      //Sort list by 24h growth descending
      //TODO: Implement sort by growth
    }
    print(list);
    return list;
  }
}
