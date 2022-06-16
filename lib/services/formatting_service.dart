import 'dart:math';
class FormattingService{
       static double roundDouble(double value, int places) {
        num mod = pow(10.0, places);
        return ((value * mod).round().toDouble() / mod);
      }

      static double calculatepercent(double first, double last) {
        return roundDouble((1 - (last / first)) * 100, 2);
      }
}