import 'dart:math';

double rads(double degrees) {
  return (degrees / 180) * pi;
}

double deg(double rads) {
  return (rads * (180 / pi));
}

double round(double value, double decimals) {
  return (value * pow(10, decimals)).roundToDouble() / pow(10, decimals);
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