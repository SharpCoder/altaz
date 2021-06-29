import 'dart:math';
import 'package:test/test.dart';
import '../src/math.dart';
import '../src/models/angle.dart';
import '../src/coordinates/converter.dart';
import '../src/coordinates/spherical.dart';

void main() {
  
  test("Spherical to Ecliptic Conversion", () {
    var sol = SphericalCoordinate(
      RA: Angle.fromDegrees(90.0),
      Decl: Angle.ZERO,
      r: 1.0,
    );

    // Verify equatorial conversion works
    var xyz = sphereToRect(sol);
    expect(xyz.x.asRad(), 0.0);
    expect(xyz.y.asRad(), 1.0);
    expect(xyz.z.asRad(), sin(0));

    // Now verify ecliptic rotation works
    var xyzEcliptic = rotateAroundX(xyz, Angle.fromDegrees(23.4));
    expect(xyzEcliptic.x.asRad(), 0.0);
    expect(round(xyzEcliptic.y.asRad(), 4), 0.9178);
    expect(round(xyzEcliptic.z.asRad(), 4), 0.3971);

    // Convert ecliptic to spherical
    var spherical = rectToSphere(xyzEcliptic);
    expect(spherical.r.round(), 1.0);
    expect(spherical.RA.asDeg().round(), 90.0);
    expect(round(spherical.Decl.asDeg(), 2), 23.4);

  });

}
