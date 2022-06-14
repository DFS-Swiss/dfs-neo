class DataContainer<T> {
  final T? data;
  final bool loading;
  final Error? error;

  DataContainer({this.data, this.loading = false, this.error});

  factory DataContainer.waiting() {
    return DataContainer(loading: true);
  }

  @override
  String toString() {
    return "{loading: $loading, error:$error, data:$data}";
  }
}
