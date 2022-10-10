import 'dart:math';

class FormattingUtils {
  static double roundDouble(double value, int places) {
    try {
      num mod = pow(10.0, places);
      return ((value * mod).round().toDouble() / mod);
    } catch (e) {
      throw "Unsupported operation: Infinity or NaN toInt";
    }
  }

  static double calculatepercent(double first, double last) {
    if (first == 0 && last == 0) return 0.0;
    return roundDouble(((first - last) / last) * 100, 2);
  }
}
