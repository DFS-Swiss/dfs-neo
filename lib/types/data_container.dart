class DataContainer<T> {
  final T? data;
  final bool loading;
  final bool refetching;
  final dynamic error;

  DataContainer(
      {this.data, this.loading = false, this.error, this.refetching = false});

  factory DataContainer.waiting() {
    return DataContainer(loading: true);
  }

  @override
  String toString() {
    return "{loading: $loading, error:$error, data:$data}";
  }
}
