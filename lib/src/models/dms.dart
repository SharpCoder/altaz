import 'dart:math';
import 'angle.dart';

class DMS {
  final double degrees;
  final double minutes;
  final double seconds;

  DMS({
    required this.degrees,
    required this.minutes,
    required this.seconds,
  });

  Angle asAngle() {
    return Angle.fromDegrees(this.asDeg());
  }

  double asDeg() {
    return this.degrees + (this.minutes / 60) + (this.seconds / 3600);
  }

  double asRad() {
    return (asDeg() / 180) * pi;
  }

  String toStr() {
    return '${this.degrees} ${this.minutes}\' ${this.seconds}"';
  }
}
