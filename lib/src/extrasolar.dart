/**
 * extrasolar.dart
 * Author: Josh Cole
 * 
 * This file contains calculatoins primarily used to decode information
 * about stars and galaxies and such. Things outside the solar system.
*/
import 'dart:math';
import 'models/angle.dart';
import 'models/gps_coordinate.dart';
import 'models/horizontal_coordinate.dart';
import 'models/spherical_coordinate.dart';

import 'core.dart';

HorizontalCoordinate calculateAltAz(
    GPSCoordinate gps, SphericalCoordinate target, DateTime instant) {
  Angle hourAngle = calculateHourAngle(instant, gps.longitude, target.ra);
  double sinAlt = sin(target.dec.asRad()) * sin(gps.latitude.asRad()) +
      cos(target.dec.asRad()) *
          cos(gps.latitude.asRad()) *
          cos(hourAngle.asRad());
  double altitude = asin(sinAlt);
  double cosA =
      (sin(target.dec.asRad()) - (sinAlt * sin(gps.latitude.asRad()))) /
          (cos(altitude) * cos(gps.latitude.asRad()));
  double azimuth = acos(cosA);

  if (sin(hourAngle.asRad()) >= 0) {
    azimuth = (2 * pi) - azimuth;
  }

  return HorizontalCoordinate(
      altitude: Angle(rads: altitude), azimuth: Angle(rads: azimuth));
}
