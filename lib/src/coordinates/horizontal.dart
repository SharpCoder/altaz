import '../models/angle.dart';

class HorizontalCoordinate {
  final Angle altitude;
  final Angle azimuth;
  
  static const HorizontalCoordinate ZERO = const HorizontalCoordinate(
    altitude: Angle.ZERO,
    azimuth: Angle.ZERO,
  );

  const HorizontalCoordinate({
    required this.altitude,
    required this.azimuth,
  });
}