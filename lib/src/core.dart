/**
 * core.dart
 * Author: Josh Cole
 * 
 * This file contains core calculations used throughout the library
 * specifically around time manipulation and angular computations.
*/
import 'dart:math';
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
