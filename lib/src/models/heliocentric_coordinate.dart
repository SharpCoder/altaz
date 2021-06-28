import 'angle.dart';

class HeliocentricCoordinate {
  final Angle L;
  final Angle B;
  final double r;

  HeliocentricCoordinate({
    required this.L, // Longitude
    required this.B, // Latitude
    required this.r, // Radius
  });
}
