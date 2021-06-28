/**
 * planetary.dart
 * Author: Josh Cole
 * 
 * This file designates all primary planetary calculations.
*/
import 'dart:math';
import 'utils.dart';
import 'core.dart';
import 'models/planetary_coefficients.dart';
import 'models/angle.dart';
import 'models/gps_coordinate.dart';
import 'models/heliocentric_coordinate.dart';
import 'models/spherical_coordinate.dart';
import 'models/vsop87_term.dart';
import 'models/xyz.dart';

List<VSOP87Term> filterTerms(String planet, List<VSOP87Term> terms) {
  return terms.where((term) => term.planet == planet).toList();
}

HeliocentricCoordinate computeHeliocentricCoordinate(
    List<VSOP87Term> terms, bool compensateForFK5, double daysJulian) {
  var polynomial = {};
  var results = {};
  var centuryTime = julianMillenniaFromEpoch2000(daysJulian);

  for (var term in terms) {
    if (!polynomial.containsKey(term.variable)) {
      polynomial[term.variable] = {};
    }

    if (!polynomial[term.variable].containsKey(term.term)) {
      polynomial[term.variable][term.term] = List<double>.empty(growable: true);
    }

    var calculation = term.A * cos(term.B + term.C * centuryTime);
    polynomial[term.variable][term.term].add(calculation);
  }

  for (var variable in polynomial.keys) {
    double calculation = 0.0;
    for (var term in polynomial[variable].keys) {
      var sum = sumList(polynomial[variable][term]);
      calculation += sum * pow(centuryTime, term);
    }

    results[variable] = calculation;
  }

  var deltaL = 0.0;
  var deltaB = 0.0;

  if (compensateForFK5) {
    var LPrime = results['L'] -
        rads(1.397) * centuryTime -
        rads(0.00031) * pow(centuryTime, 2);

    deltaL = rads(-0.09033 / 3600) +
        rads((-0.03916 / 3600)) *
            (cos(LPrime) + sin(LPrime)) *
            tan(results['B']);

    deltaB = rads(0.03916 / 3600) * (cos(LPrime) - sin(LPrime));
  }

  return HeliocentricCoordinate(
      B: Angle(rads: results['B'] + deltaB),
      L: Angle(rads: results['L'] + deltaL),
      r: results['r']);
}

HeliocentricCoordinate computeHeliocentricCoordinateFromCoefficients(
    PlanetaryCoefficients coefficients, double daysJulian) {
  print("******** ${coefficients.name} ********");

  // First we need to compute E
  var d = julianToDayNumber(daysJulian);
  var N = Angle.fromDegrees(
          sumAndExponentiallyMultiply(coefficients.longitudeOfAscendingNode, d))
      .rev();
  var i = Angle.fromDegrees(
          sumAndExponentiallyMultiply(coefficients.inclination, d))
      .rev();
  var w = Angle.fromDegrees(
          sumAndExponentiallyMultiply(coefficients.argumentOfPerihelion, d))
      .rev();
  var a = Angle.fromDegrees(
          sumAndExponentiallyMultiply(coefficients.semimajorAxis, d))
      .rev();
  var M = Angle.fromDegrees(
          sumAndExponentiallyMultiply(coefficients.meanAnomaly, d))
      .rev();
  var e = sumAndExponentiallyMultiply(coefficients.eccentricity, d);

  var E0 = M.asRad() * e * sin(M.asRad()) * (1 + e * cos(M.asRad()));
  // Converge on error
  for (var i = 0; i < 50; i++) {
    var E1 = E0 - (E0 - e * sin(E0) - M.asRad()) / (1 - e * cos(E0));
    if ((E0 - E1).abs() < rads(0.005)) {
      E0 = E1;
      break;
    } else {
      E0 = E1;
    }
  }

  var E = Angle(rads: E0).rev();
  // var E = Angle.fromDegrees(262.9735);

  print("N = ${N.asDeg()}");
  print("i = ${i.asDeg()}");
  print("w = ${w.asDeg()}");
  print("a = ${a.asDeg()}");
  print("e = ${e}");
  print("M = ${M.asDeg()}");
  print("E0 = ${E.asDeg()}");

  // Compute rectangular XY coordinates
  var x = Angle(rads: a.asRad() * (cos(E.asRad()) - e));
  var y = Angle(rads: a.asRad() * sqrt(1.0 - pow(e, 2)) * sin(E.asRad()));

  print("x = ${x.asDeg()}");
  print("y = ${y.asDeg()}");

  // Convert to distance and true anomaly
  var r = sqrt(x.asDeg() * x.asDeg() + y.asDeg() * y.asDeg()); // Earth radii
  var v = Angle(rads: atan2(y.asRad(), x.asRad())).rev(); // True anomaly

  print("r = $r");
  print("v = ${v.asDeg()}");

  // Compute ecliptic coordinates
  var xeclip = r *
      (cos(N.asRad()) * cos(v.asRad() + w.asRad()) -
          sin(N.asRad()) * sin(v.asRad() + w.asRad()) * cos(i.asRad()));

  var yeclip = r *
      (sin(N.asRad()) * cos(v.asRad() + w.asRad()) +
          cos(N.asRad()) * sin(v.asRad() + w.asRad() * cos(i.asRad())));

  var zeclip = r * sin(v.asRad() + w.asRad()) * sin(i.asRad());

  print("xeclip = ${xeclip}");
  print("yeclip = ${yeclip}");
  print("zeclip = ${zeclip}");

  // Finally, convert to lat/lon
  return HeliocentricCoordinate(
      L: Angle(rads: atan2(yeclip, xeclip)),
      B: Angle(rads: atan2(zeclip, sqrt(xeclip * xeclip + yeclip * yeclip))),
      r: sqrt(xeclip * xeclip + yeclip * yeclip + zeclip * zeclip));
}

XYZ computeXYZ(List<VSOP87Term> targetTerms, List<VSOP87Term> earthTerms,
    bool compensateForFK5, double daysJulian) {
  HeliocentricCoordinate targetCoord =
      computeHeliocentricCoordinate(targetTerms, compensateForFK5, daysJulian);

  HeliocentricCoordinate earthCoord =
      computeHeliocentricCoordinate(earthTerms, compensateForFK5, daysJulian);

  Angle x = Angle(
      rads: (targetCoord.r *
              cos(targetCoord.B.asRad()) *
              cos(targetCoord.L.asRad())) -
          (earthCoord.r *
              cos(earthCoord.B.asRad()) *
              cos(earthCoord.L.asRad())));

  Angle y = Angle(
      rads: (targetCoord.r *
              cos(targetCoord.B.asRad()) *
              sin(targetCoord.L.asRad())) -
          (earthCoord.r *
              cos(earthCoord.B.asRad()) *
              sin(earthCoord.L.asRad())));

  Angle z = Angle(
      rads: (targetCoord.r * sin(targetCoord.B.asRad())) -
          (earthCoord.r * sin(earthCoord.B.asRad())));

  return XYZ(X: x, Y: y, Z: z);
}

SphericalCoordinate computeSphericalCoordinatesFromCoefficients(
  PlanetaryCoefficients coefficients,
  DateTime instant,
) {
  var daysJulian = instantToDaysJulian(instant);
  var d = julianToDayNumber(daysJulian);
  var heliocentricCoordinates =
      computeHeliocentricCoordinateFromCoefficients(coefficients, daysJulian);

  var longitude = heliocentricCoordinates.L;
  var latitude = heliocentricCoordinates.B;
  var r = heliocentricCoordinates.r;
  var e = obliquityOfEcliptic(daysJulian);
  var oblecl = Angle.fromDegrees(23.4393 - 3.563E-7 * d);

  // Parallax
  var xeclip = r * cos(longitude.asRad()) * cos(latitude.asRad());
  var yeclip = r * sin(longitude.asRad()) * cos(latitude.asRad());
  var zeclip = r * sin(latitude.asRad());

  var xequat = xeclip;
  var yequat = yeclip * cos(oblecl.asRad()) - zeclip * sin(oblecl.asRad());
  var zequat = yeclip * sin(oblecl.asRad()) + zeclip * cos(oblecl.asRad());

  var mpar = (1 / heliocentricCoordinates.r);

  print("long = ${longitude.asDeg()}");
  print("lat = ${latitude.asDeg()}");
  print("r = ${heliocentricCoordinates.r}");
  print("mpar = $mpar");

  // Now convert these to topocentric
  Angle ra = Angle(rads: atan2(yeclip, xequat));
  Angle dec =
      Angle(rads: atan2(zequat, sqrt(xequat * xequat + yequat * yequat)));

  var gclat = latitude;
  var rho = 1.0;
  var HA = calculateHourAngle(instant, longitude, ra);
  var g = Angle(rads: atan(tan(gclat.asRad()) / cos(HA.asRad())));

  var topRA = Angle(
      rads: ra.asRad() -
          mpar * rho * cos(gclat.asRad()) * sin(HA.asRad()) / cos(dec.asRad()));

  print("RA (topocentric) = ${topRA.rev().asDeg()}");
  return SphericalCoordinate(ra: ra, dec: dec);
}

SphericalCoordinate computeSphericalCoordinates(List<VSOP87Term> targetTerms,
    List<VSOP87Term> earthTerms, DateTime instant) {
  var daysJulian = instantToDaysJulian(instant);
  XYZ iteration1 = computeXYZ(targetTerms, earthTerms, false, daysJulian);
  double earthDistance = sqrt(pow(iteration1.X.asRad(), 2) +
      pow(iteration1.Y.asRad(), 2) +
      pow(iteration1.Z.asRad(), 2));

  double lightTime = earthDistance * 0.0057755183;
  // daysJulian = daysJulian - lightTime;
  XYZ iteration2 =
      computeXYZ(targetTerms, earthTerms, true, daysJulian - lightTime);

  Angle geocentricLongitude =
      Angle(rads: atan2(iteration2.Y.asRad(), iteration2.X.asRad()));

  Angle geocentricLatitude = Angle(
      rads: atan2(iteration2.Z.asRad(),
          sqrt(pow(iteration2.X.asRad(), 2) + pow(iteration2.Y.asRad(), 2))));

  // Calculate aberration effects
  HeliocentricCoordinate earthCoord =
      computeHeliocentricCoordinate(earthTerms, false, daysJulian);
  var theta = Angle.fromDegrees(earthCoord.L.asDeg() + 180);
  var aberration = calculateAberration(
      theta, geocentricLongitude, geocentricLatitude, daysJulian);

  // Calculate nutation effects
  var nutation = calculateNutation(daysJulian);
  Angle e = Angle(
      rads: obliquityOfEcliptic(daysJulian).asRad() +
          nutation.deltaObliquity.asRad());

  Angle apparentLongitude = Angle(
      rads: geocentricLongitude.asRad() +
          nutation.deltaLongitude.asRad() +
          aberration.deltaLongitude.asRad());

  Angle apparentLatitude = Angle(
      rads: geocentricLatitude.asRad() + aberration.deltaLatitude.asRad());

  /* 
    Note: There's a small, easily missed addendum at the end of the definition 
    for how to calcualte this. And said addendum highlights the fact that 
    you must use atan2 for these coordinates, in some capacity, otherwise the 
    quadrants will be off. 
  */
  Angle ra = Angle(
      rads: atan2(
          (sin(apparentLongitude.asRad()) * cos(e.asRad()) -
              tan(apparentLatitude.asRad()) * sin(e.asRad())),
          cos(apparentLongitude.asRad())));

  Angle dec = Angle(
      rads: asin(sin(apparentLatitude.asRad()) * cos(e.asRad()) +
          cos(apparentLatitude.asRad()) *
              sin(e.asRad()) *
              sin(apparentLongitude.asRad())));

  return SphericalCoordinate(ra: ra, dec: dec);
}
