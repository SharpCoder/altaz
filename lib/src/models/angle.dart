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
    return rads;
  }

  double asDeg() {
    return ((asRad() * 180) / pi);
  }

  DMS asDMS() {
    double degrees = asDeg();
    double minutes = (degrees - degrees.floor()) * 60;
    double seconds = (minutes - minutes.floor()) * 60;

    return DMS(
      degrees: degrees.floorToDouble(),
      minutes: minutes.floorToDouble(),
      seconds: seconds.floorToDouble(),
    );
  }

  HMS asHMS() {
    double degrees = asDeg();
    double hours = (degrees / 15.0);
    double minutes = (hours - hours.floor()) * 60;
    double seconds = (minutes - minutes.floor()) * 60;

    return HMS(hours: hours.floorToDouble(), minutes: minutes.floorToDouble(), seconds: seconds.floorToDouble());
  }

  Angle rev() {
    var rads = this.rads;
    rads = rads - (rads / (2 * pi)).floor() * (2 * pi);
    return Angle(rads: rads);
  }
}
