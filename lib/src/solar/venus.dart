import 'dart:math';
import 'body.dart';
import '../math.dart';

class Venus extends Body {

  Venus(double d) : super(
    d: d,
    N: [76.6799, 2.46590E-5],
    i: [3.3946, 2.75E-8],
    w: [54.8910, 1.38374E-5],
    a: [0.723330],
    e: [0.006773, -1.302E-9],
    M: [48.0052, 1.6021302244],
    s: 0.723,
  );

  @override
  double magnitude() {
    var attrs = planetaryAttributes();
    return -4.34 + 5*log10(attrs.geocentricDistance * attrs.heliocentricDistance) + 0.013 * attrs.phaseAngle.asDeg() + 4.2E-7 * pow(attrs.phaseAngle.asDeg(), 3);
  }
}