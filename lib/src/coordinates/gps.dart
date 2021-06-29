import '../models/angle.dart';

class GPSCoordinate {
  final Angle latitude;
  final Angle longitude;
  static const GPSCoordinate ZERO = const GPSCoordinate(
    latitude: Angle.ZERO,
    longitude: Angle.ZERO,
  );

  const GPSCoordinate({
    required this.latitude,
    required this.longitude,
  });
}