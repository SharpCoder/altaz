import 'dart:io';
import 'package:test/test.dart';
import '../src/utils.dart';
import '../src/core.dart';
import '../src/db/planets.dart';
import '../src/parsers/vsop87_parser.dart';
import '../src/planetary.dart';
import '../src/models/gps_coordinate.dart';
import '../src/models/angle.dart';
import '../src/extrasolar.dart';

void main() {
  var vsop87 = File("./lib/tests/db/vsop87_flat.csv").readAsStringSync();
  var terms = parse_vsop87(vsop87);

  // test('Calculatoin of orbital elements', () {
  //   var instant = DateTime.parse("2065-06-24 00:00:00Z");
  //   var daysJulian = instantToDaysJulian(instant);
  //   var centuryTime = julianToCenturyTime(daysJulian);
  //   var orbitalElements = OrbitalElements.calculate(
  //     Mercury,
  //     centuryTime,
  //   );

  //   expect(roundDouble(orbitalElements.meanLongitude.asDeg(), 6), 203.494702);
  //   expect(roundDouble(orbitalElements.semimajorAxis, 6), 0.387098);
  //   expect(roundDouble(orbitalElements.eccentricity, 6), 0.205645);
  //   expect(roundDouble(orbitalElements.inclination.asDeg(), 6),
  //       7.006186); // 7.006171);
  //   expect(roundDouble(orbitalElements.longitudeOfAscendingNode.asDeg(), 6),
  //       49.107650);
  //   expect(roundDouble(orbitalElements.longitudeOfPerihelion.asDeg(), 6),
  //       78.475382);
  //   expect(roundDouble(orbitalElements.meanAnomaly.asDeg(), 6), 125.019320);
  //   expect(roundDouble(orbitalElements.argumentOfPerihelion.asDeg(), 6),
  //       29.367731); // 29.367732
  // });

  test('Heliocentric coordinate calculation', () {
    // var filtered = filterTerms("VENUS", terms);
    // var instant = DateTime.parse("1992-12-20 00:00:00Z");
    // var daysJulian = instantToDaysJulian(instant);
    // var coordinates =
    //     computeHeliocentricCoordinate(filtered, false, daysJulian);

    // expect(coordinates.L.asDeg() % 360, 26.114119595141347);
  });

  test('Apparent position of venus', () {
    // var venusTerms = filterTerms("VENUS", terms);
    // var earthTerms = filterTerms("EARTH", terms);
    // var instant = DateTime.parse("1992-12-20 00:00:00Z");
    // var daysJulian = instantToDaysJulian(instant);
    // var coordinates =
    //     computeSphericalCoordinates(venusTerms, earthTerms, daysJulian);

    // expect(coordinates.dec.asDeg() % 360, -18.8802 % 360);
    // expect(coordinates.ra.asDeg() % 360, 316.17291);
  });

  // test('Position of Moon in April 1990', () {
  //   var coeffs = Moon;
  //   var instant = DateTime.parse("1990-04-19 00:00:00Z");
  //   var coordinates =
  //       computeSphericalCoordinatesFromCoefficients(coeffs, instant);

  //   print("RA ${coordinates.ra.rev().asDeg()}");
  //   print("DEC ${coordinates.dec.asDeg()}");
  //   expect(true, false);
  // });

  test('Current position of venus', () {
    // var venusTerms = filterTerms("VENUS", terms);
    // var earthTerms = filterTerms("EARTH", terms);
    // var instant = DateTime.parse("2021-06-26 12:02:00Z");

    var instant = DateTime.parse("1990-04-19 00:00:00Z");
    var gps = GPSCoordinate(
        longitude: Angle.fromDegrees(-80.6043557),
        latitude: Angle.fromDegrees(28.394591));

    var vCoeffs = Mercury;

    var coordinates =
        computeSphericalCoordinatesFromCoefficients(vCoeffs, instant);
    // computeSphericalCoordinates(venusTerms, earthTerms, instant);

    var altaz = calculateAltAz(gps, coordinates, instant);

    print(coordinates.ra.asHMS().toStr());
    print(coordinates.dec.asDMS().toStr());
    print(altaz.altitude.asDeg());
    print(altaz.azimuth.asDeg());

    expect(coordinates.ra.asDeg() % 360, 316.17291);
    // expect(coordinates.dec.asDeg() % 360, -18.8802 % 360);
  });
}
