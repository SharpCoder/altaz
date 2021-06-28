import 'dart:math';

import 'package:altaz/src/utils.dart';

class PlanetaryCoefficients {
  final String name;
  final List<double> longitudeOfAscendingNode;
  final List<double> inclination;
  final List<double> argumentOfPerihelion;
  final List<double> semimajorAxis;
  final List<double> eccentricity;
  final List<double> meanAnomaly;

  PlanetaryCoefficients({
    required this.name,
    required this.longitudeOfAscendingNode,
    required this.inclination,
    required this.argumentOfPerihelion,
    required this.semimajorAxis,
    required this.eccentricity,
    required this.meanAnomaly,
  });
}
