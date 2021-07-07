import 'angle.dart';

class PlanetaryAttributes {
  final double geocentricDistance;
  final double heliocentricDistance;
  final Angle phaseAngle;
  final Angle elongation;
  final double phase;

  PlanetaryAttributes({
    required this.geocentricDistance,
    required this.heliocentricDistance,
    required this.phaseAngle,
    required this.elongation,
    required this.phase,
  });
}