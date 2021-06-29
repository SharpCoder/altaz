import '../models/angle.dart';

class SphericalCoordinate {
  final double r;
  final Angle RA;
  final Angle Decl;

  SphericalCoordinate({
    required this.r,
    required this.RA,
    required this.Decl,
  });
}