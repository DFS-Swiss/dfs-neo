import 'package:neo/models/stockdatadocument.dart';

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
    print(list);
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

    } else if (state == 4) {
      //Sort list by 24h growth descending

    }
    print(list);
    return list;
  }
}
