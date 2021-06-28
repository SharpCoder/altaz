import 'dart:math';
import 'dms.dart';
import 'hms.dart';

class Angle {
  final double rads;
  static const Angle ZERO = const Angle(rads: 0.0);

  const Angle({
    required this.rads,
  });

  static Angle fromDegrees(double degrees) {
    return Angle(rads: (degrees / 180.0) * pi);
  }

  double asRad() {
    // This will effectively constrain all angles to between -360 and 360
    // the reason we keep negatives is for atan2 and the reason we constrain
    // is for accuracy of trigonmetric functions. Probably unecessary but
    // a good idea all the same.
    return rads;

    // if (rads < 0) {
    //   return -(rads.abs() % (2 * pi));
    // }

    // return rads % (2 * pi);
  }

  double asDeg() {
    return ((asRad() * 180) / pi);
  }

  DMS asDMS() {
    double degrees = asDeg();
    double minutes = ((degrees - degrees.floorToDouble()) * 60).floorToDouble();
    double seconds =
        ((((degrees - degrees.floorToDouble()) * 60) - minutes) * 60)
            .floorToDouble();
    return DMS(
      degrees: degrees.floorToDouble(),
      minutes: minutes,
      seconds: seconds,
    );
  }

  HMS asHMS() {
    double degrees = asDeg();
    double hours = (degrees / 15.0).floorToDouble();
    double minutes = ((degrees - degrees.floorToDouble()) * 60).floorToDouble();
    double seconds =
        ((((degrees - degrees.floorToDouble()) * 60) - minutes) * 60)
            .floorToDouble();

    return HMS(hours: hours, minutes: minutes, seconds: seconds);
  }

  Angle rev() {
    var rads = this.rads;
    rads = rads - (rads / (2 * pi)).floor() * (2 * pi);
    return Angle(rads: rads);
  }
}
