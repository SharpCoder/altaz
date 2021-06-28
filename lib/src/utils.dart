import 'dart:math';

double sumList(List<double> values) {
  double result = 0.0;
  for (var value in values) {
    result += value;
  }
  return result;
}

double sumAndExponentiallyMultiply(List<double> values, double multiplier) {
  double result = 0.0;
  for (int i = 0; i < values.length; i++) {
    if (i == 0) {
      result += values[i];
    } else {
      result += values[i] * pow(multiplier, i);
    }
  }
  return result;
}

double roundDouble(double value, int places) {
  double mod = pow(10.0, places).toDouble();
  return ((value * mod).round().toDouble() / mod);
}
