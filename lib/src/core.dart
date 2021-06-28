/**
 * core.dart
 * Author: Josh Cole
 * 
 * This file contains core calculations used throughout the library
 * specifically around time manipulation and angular computations.
*/
import 'dart:math';
import 'models/aberration.dart';
import 'models/dms.dart';
import 'models/nutation.dart';
import 'models/angle.dart';

double rads(double degrees) {
  return (degrees / 180) * pi;
}

double timeToDec(double hours, double minutes, double seconds) {
  return hours + (minutes / 60) + (seconds / 3600);
}

Angle timeToAngle(double hours, double minutes, double seconds) {
  // NOTE: according this website, we should consider
  // 15.04107 instead of 15.0 http://www.stjarnhimlen.se/comp/riset.html
  return Angle.fromDegrees(timeToDec(hours, minutes, seconds) * 15);
}

double instantToDaysJulian(DateTime instant) {
  // Add the hour decimal.
  double day = instant.day +
      timeToDec(instant.hour.toDouble(), instant.minute.toDouble(),
              instant.second.toDouble()) /
          24.0;
  double month = instant.month.toDouble();
  double year = instant.year.toDouble();

  // If we are calculating for january or february, consider it the "13th and 14th"
  // months.
  if (month == 1.0 || month == 2.0) {
    year = year - 1.0;
    month = month + 12.0;
  }

  double A = (year / 100.0).floorToDouble();
  double B = 2.0 - A + (A / 4.0).floorToDouble();
  return (365.25 * (year + 4716.0)).floorToDouble() +
      (30.6001 * (month + 1.0)).floorToDouble() +
      day +
      B -
      1524.5;
}

double julianToDayNumber(double daysJulian) {
  return daysJulian - 2451543.5;
}

double julianToCenturyTime(double julianDate) {
  return (julianDate - 2451545.0) / 36525.0;
}

double julianMillenniaFromEpoch2000(double julianDays) {
  return (julianDays - 2451545.0) / 365250.0;
}

double julianCenturiesFromEpoch2000(double julianDays) {
  return 10 * julianMillenniaFromEpoch2000(julianDays);
}

Angle obliquityOfEcliptic(double julianDays) {
  var centuryTime = julianCenturiesFromEpoch2000(julianDays);
  var term1 = DMS(degrees: 23, minutes: 26, seconds: 41.448);
  var term2 = DMS(degrees: 0, minutes: 0, seconds: 4680.93);
  var u = centuryTime / 100;

  return Angle.fromDegrees(
      DMS(degrees: 23, minutes: 26, seconds: 21.448).asDeg() -
          DMS(degrees: 0, minutes: 0, seconds: 46.8150).asDeg() * centuryTime -
          DMS(degrees: 0, minutes: 0, seconds: 0.00059).asDeg() *
              pow(centuryTime, 2) +
          DMS(degrees: 0, minutes: 0, seconds: 0.001813).asDeg() *
              pow(centuryTime, 3));

  // return Angle.fromDegrees(term1.asDeg() -
  //     term2.asDeg() * u -
  //     1.55 * pow(u, 2) +
  //     1999.25 * pow(u, 3) -
  //     51.38 * pow(u, 4) -
  //     249.67 * pow(u, 5) -
  //     39.05 * pow(u, 6) +
  //     7.12 * pow(u, 7) +
  //     27.87 * pow(u, 8) +
  //     5.79 * pow(u, 9) +
  //     2.45 * pow(u, 10));
}

Nutation calculateNutation(double daysJulian) {
  var centuryTime = julianMillenniaFromEpoch2000(daysJulian);
  var longitudeOfAscendingNodeMoon = Angle.fromDegrees(125.04452 -
      1934.136261 * centuryTime +
      0.0020708 * pow(centuryTime, 2) +
      pow(centuryTime, 3) / 450000);

  Angle meanLongitudeOfSun =
      Angle.fromDegrees(280.4665 + 36000.7698 * centuryTime);
  Angle meanLongitudeOfMoon =
      Angle.fromDegrees(218.3165 + 481267.8813 * centuryTime);

  // Simplified nutation calculation
  var deltaLongitude = Angle(
      rads: rads(-17.20 / 3600) * sin(longitudeOfAscendingNodeMoon.asRad()) -
          rads(1.32 / 3600) * sin(2 * meanLongitudeOfSun.asRad()) -
          rads(.23 / 3600) * sin(2 * meanLongitudeOfMoon.asRad()) +
          rads(.21 / 3600) * sin(2 * longitudeOfAscendingNodeMoon.asRad()));

  var deltaObliquity = Angle(
      rads: rads(9.20 / 3600) * cos(longitudeOfAscendingNodeMoon.asRad()) +
          rads(0.57 / 3600) * cos(2 * meanLongitudeOfSun.asRad()) +
          rads(0.10 / 3600) * cos(2 * meanLongitudeOfMoon.asRad()) -
          rads(0.09 / 3600) * cos(2 * longitudeOfAscendingNodeMoon.asRad()));

  return Nutation(
      deltaLongitude: deltaLongitude, deltaObliquity: deltaObliquity);
}

Aberration calculateAberration(
    Angle theta, Angle longitude, Angle latitude, double daysJulian) {
  var centuryTime = julianCenturiesFromEpoch2000(daysJulian);
  var eccentricity = 0.016708617 -
      0.000042037 * centuryTime -
      0.0000001236 * pow(centuryTime, 2);
  var longitudeOfPerihelion = rads(102.93735) +
      rads(0.71953 * centuryTime) +
      rads(0.00046 * pow(centuryTime, 2));
  var constnatOfAberration = rads(20.49552 / 3600);

  return Aberration(
      deltaLongitude: Angle(
          rads:
              (-constnatOfAberration * cos(theta.asRad() - longitude.asRad()) +
                      eccentricity *
                          constnatOfAberration *
                          cos(longitudeOfPerihelion - longitude.asRad())) /
                  cos(latitude.asRad())),
      deltaLatitude: Angle(
          rads: -constnatOfAberration *
              sin(latitude.asRad()) *
              (sin(theta.asRad() - longitude.asRad()) -
                  eccentricity *
                      sin(longitudeOfPerihelion - longitude.asRad()))));
}

Angle calculateLocalMeanSiderealTime(DateTime instant, Angle longitude) {
  // Verify we're always working with UTC since this function is calculating
  // position at greenwich
  if (!instant.isUtc) {
    instant = instant.toUtc();
  }

  double julianDays = instantToDaysJulian(instant);
  double centuryTime = julianToCenturyTime(julianDays);

  // Mean sidereal time (in degrees) at greenwich for an instant.
  double LMST = 280.46061837 +
      360.98564736629 * (julianDays - 2451545.0) +
      0.000387933 * pow(centuryTime, 2) -
      (pow(centuryTime, 3) / 38710000.0);

  // Adjust the location (which is already represented in a degree decimal).
  LMST += longitude.asDeg();

  // Bring it within range.
  double range = 360.0;
  while (LMST < 0.0 || LMST > range) {
    if (LMST > range)
      LMST -= range;
    else
      LMST += range;
  }

  // Now we have the LMST
  return Angle.fromDegrees(LMST);
}

Angle calculateHourAngle(DateTime instant, Angle longitude, Angle ra) {
  Angle result = calculateLocalMeanSiderealTime(instant, longitude);
  double degrees = result.asDeg();
  if (degrees < 0) {
    degrees += 360;
  }

  return Angle.fromDegrees(degrees);
}
