class PriceDevelopmentDatapoint {
  double price;
  final DateTime time;

  PriceDevelopmentDatapoint({required this.price, required this.time});

  factory PriceDevelopmentDatapoint.empty() {
    return PriceDevelopmentDatapoint(price: 0, time: DateTime.now());
  }
}
