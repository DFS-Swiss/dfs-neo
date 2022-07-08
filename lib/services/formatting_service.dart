import 'dart:math';

class FormattingService {
  static double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    if (value == null) return 0;
    return ((value * mod).round().toDouble() / mod);
  }

  static double calculatepercent(double first, double last) {
    if (first == 0 && last == 0) return 0.0;
    return roundDouble((1 - (last / first)) * 100, 2);
  }
}
