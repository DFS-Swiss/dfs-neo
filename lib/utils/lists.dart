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
}
