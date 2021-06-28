/**
 * solar.dart
 * Author: Josh Cole
 * 
 * This file designates all primary solar calculations.
*/
import 'dart:math';
import 'core.dart';
import 'models/angle.dart';
import 'models/orbital_context.dart';
import 'models/spherical_coordinate.dart';
import 'models/xyz.dart';

OrbitalContext calculatePostionOfSun(DateTime instant) {
  var daysJulian = instantToDaysJulian(instant);
  var d = julianToDayNumber(daysJulian);
  print("d $d");
  var w = Angle.fromDegrees(282.9404 + 4.70935E-5 * d);
  var a = 1.0000000;
  var e = 0.016709 - 1.151E-9;
  var M = Angle.fromDegrees(356.0470 + 0.9856002585 * d).rev();

  print("w ${w.asDeg()}");
  print("M ${M.asDeg()}");
  // Obtain the suns mean longitude
  var L = Angle.fromDegrees(w.asDeg() + M.asDeg());
  print("L ${L.asDeg()}");
  var oblecl = Angle.fromDegrees(23.4393 - 3.563E-7 * d);
  var E = Angle.fromDegrees(
      M.asDeg() + (180 / pi) * e * sin(M.asRad()) * (1 + e * cos(M.asRad())));
  print("oblecl ${oblecl.asDeg()}");
  print("E ${E.asDeg()}");
  print("e ${e}");
  // Now compute the rectangular coordinates in the plane of the ecliptic
  var x = Angle(rads: cos(E.asRad()) - e);
  var y = Angle(rads: sin(E.asRad()) * sqrt(1.0 - pow(e, 2)));

  // Convert to distance and true anomaly
  var r = sqrt(pow(x.asRad(), 2) + pow(y.asRad(), 2));
  var v = atan2(y.asRad(), x.asRad());

  print("x ${x.asRad()}");
  print("y ${y.asRad()}");
  // Compute the logitude
  var lon = Angle(rads: v + w.asRad());

  // Calculate ecliptic rectangular coordinates
  var xEclip = Angle(rads: r * cos(lon.asRad()));
  var yEclip = Angle(rads: r * sin(lon.asRad()));
  var zEclip = 0.0;

  print("xEclip ${xEclip.asRad()}");
  print("yEclip ${yEclip.asRad()}");

  // Rotate them to equitorail coordinates
  var xEquat = xEclip;
  var yEquat = Angle(
      rads:
          yEclip.asRad() * cos(oblecl.asRad()) - zEclip * sin(oblecl.asRad()));
  var zEquat = Angle(
      rads:
          yEclip.asRad() * sin(oblecl.asRad()) + zEclip * cos(oblecl.asRad()));

  // Finally compute spherical coordinates
  var RA = Angle(rads: atan2(yEquat.asRad(), xEquat.asRad()));
  var dec = Angle(
      rads: atan2(zEquat.asRad(),
          sqrt(pow(xEquat.asRad(), 2) + pow(yEquat.asRad(), 2))));

  return OrbitalContext(
    xyz: XYZ(X: x, Y: y, Z: Angle.ZERO),
    xyzEquat: XYZ(X: xEquat, Y: yEquat, Z: zEquat),
    sphericalCoordinates: SphericalCoordinate(ra: RA, dec: dec),
    longitude: lon.rev(),
    r: r,
  );
}
