import 'dart:math';
import 'body.dart';
import '../math.dart';

class Mercury extends Body {

  Mercury(double d) : super(
    d: d,
    N: [48.3313, 3.24587E-5],
    i: [7.0047, 5.00E-8],
    w: [29.1241, 1.01444E-5],
    a: [0.387098],
    e: [0.205635, 5.59E-10],
    M: [168.6562, 4.0923344368],
    s: 0.39,
  );

  @override
  double magnitude() {
    var attrs = planetaryAttributes();
    return 
      -0.36 
      + 5 * log10(attrs.heliocentricDistance * attrs.geocentricDistance) 
      + 0.027 * attrs.phaseAngle.rev().asDeg()
      + 2.2E-13 * pow(attrs.phaseAngle.asDeg(), 6);
  }
}