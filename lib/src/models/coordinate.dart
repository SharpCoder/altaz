import 'dart:svg';

import 'angle.dart';

class Coordinate {
  final Angle longitude;
  final Angle latitude;

  Coordinate({
    required this.longitude,
    required this.latitude,
  });

  static Coordinate fromDegrees(double longitude, double latitude) {
    return Coordinate(latitude: Angle.fromDegrees(latitude), longitude: Angle.fromDegrees(longitude));
  }
}