import 'dart:math';

class Angle {
    final double rads;
    static const Angle ZERO = const Angle(rads: 0.0);

    const Angle({
      required this.rads,
    });

    static Angle fromDegrees(double degrees) {
      return Angle(rads: (degrees / 180) * pi);
    }

    double asRad() {
      return rads;
    }

    double asDeg() {
      return (rads * 180) / pi;
    }
}