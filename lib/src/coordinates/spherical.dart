import '../models/angle.dart';

class Spherical {
  final double r;
  final Angle RA;
  final Angle Decl;

  Spherical({
    required this.r,
    required this.RA,
    required this.Decl,
  });
}