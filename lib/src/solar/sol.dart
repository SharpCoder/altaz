import 'body.dart';

class Sol extends Body {

  Sol(double d) : super(
    N: [],
    i: [],
    d: d,
    w: [282.9404, 4.70935E-5],
    a: [1.00000],
    e: [0.016709, -1.151E-9],
    M: [356.0470, 0.9856002585],
    orbitsEarth: true, // we suspend disbelief, for math
  );
}