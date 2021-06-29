import 'dart:math';
import '../models/angle.dart';
import '../core.dart';
import 'rectangular.dart';
import 'spherical.dart';
import 'horizontal.dart';
import 'gps.dart';

Rectangular sphereToRect(Spherical sphere) {
  return Rectangular(
    x: Angle(rads: sphere.r * cos(sphere.RA.asRad()) * cos(sphere.Decl.asRad())),
    y: Angle(rads: sphere.r * sin(sphere.RA.asRad()) * cos(sphere.Decl.asRad())),
    z: Angle(rads: sphere.r * sin(sphere.Decl.asRad())),
  );
}

Spherical rectToSphere(Rectangular rect) {
  return Spherical(
    r: sqrt(pow(rect.x.asRad(), 2) + pow(rect.y.asRad(), 2) + pow(rect.z.asRad(), 2)),
    RA: Angle(rads: atan2( rect.y.asRad(), rect.x.asRad())).rev(),
    Decl: Angle(rads: atan2(rect.z.asRad(), sqrt(pow(rect.x.asRad(), 2) + pow(rect.y.asRad(), 2)))),
  );
}

/**
 * This method will rotate a rectancular coordinate system around the X
 * axis through the angle of oblecl. In other words, convert ecliptic to
 * equatorial.
 */
Rectangular rotateAroundX(Rectangular rect, Angle oblecl) {
  return Rectangular(
    x: rect.x,
    y: Angle(rads: rect.y.asRad() * cos(oblecl.asRad()) - rect.z.asRad() * sin(oblecl.asRad())),
    z: Angle(rads: rect.y.asRad() * sin(oblecl.asRad()) + rect.z.asRad() * cos(oblecl.asRad()))
  );
}

/**
 * This method will take a Spherical coordinate and translate it
 * to Horizontal (Alt/Az), while adjusting for the local hour angle
 * at an instant.
 */
Horizontal sphereToHorizontal(GPS gps, Spherical target, DateTime instant) {
  Angle hourAngle = calculateHourAngle(instant, gps.longitude, target.RA);
  double sinAlt = sin(target.Decl.asRad()) * sin(gps.latitude.asRad()) +
      cos(target.Decl.asRad()) *
          cos(gps.latitude.asRad()) *
          cos(hourAngle.asRad());
  double altitude = asin(sinAlt);
  double cosA =
      (sin(target.Decl.asRad()) - (sinAlt * sin(gps.latitude.asRad()))) /
          (cos(altitude) * cos(gps.latitude.asRad()));
  double azimuth = acos(cosA);

  if (sin(hourAngle.asRad()) >= 0) {
    azimuth = (2 * pi) - azimuth;
  }

  return Horizontal(
      altitude: Angle(rads: altitude), 
      azimuth: Angle(rads: azimuth)
  );
}
