import 'angle.dart';

class GPSCoordinate {
  final Angle longitude;
  final Angle latitude;

  GPSCoordinate({
    required this.longitude,
    required this.latitude,
  });

  static GPSCoordinate fromDegrees(double longitude, double latitude) {
    return GPSCoordinate(
        latitude: Angle.fromDegrees(latitude),
        longitude: Angle.fromDegrees(longitude));
  }
}
