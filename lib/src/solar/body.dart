import 'dart:math';

import 'sol.dart';
import '../math.dart';
import '../models/angle.dart';
import '../models/planetaryAttributes.dart';
import '../coordinates/spherical.dart';
import '../coordinates/rectangular.dart';
import '../coordinates/converter.dart';

const bool _DEBUG = false;

/**
 * This class represents a solar body and the arguments
 * of its orbit which are needed to calculate its position.
 * 
 * Many solar bodies have their own nuances, so it's all going
 * to be done one-off, but common code will live in the Body class.
 */
abstract class Body {
  late final double d;
  late final Angle N; // Longitude of the ascending node
  late final Angle i; // inclination
  late final Angle w; // Longitude of perihelion
  late final double a; // mean distance
  late final double e; // eccentricity
  late final Angle M; // mean anomaly
  late final Angle L; // mean longitude
  late final Angle oblecl; // oblequity of the ecliptic 
  late final double s; // Distance from the sun
  final bool orbitsEarth; // If true, this body is simulated to orbit the earth

  Body ({
    required this.d,
    required List<double> N,
    required List<double> i,
    required List<double> w,
    required List<double> a,
    required List<double> e,
    required List<double> M,
    required this.s,
    this.orbitsEarth = false,
  }) {
    this.N = Angle.fromDegrees(sumAndExponentiallyMultiply(N, d));
    this.i = Angle.fromDegrees(sumAndExponentiallyMultiply(i, d));
    this.w = Angle.fromDegrees(sumAndExponentiallyMultiply(w, d));
    this.a = sumAndExponentiallyMultiply(a, d);
    this.e = sumAndExponentiallyMultiply(e, d);
    this.M = Angle.fromDegrees(sumAndExponentiallyMultiply(M, d)).rev();
    this.L = Angle.fromDegrees(this.w.asDeg() + this.M.asDeg()).rev();
    this.oblecl = Angle.fromDegrees(23.4393 - 3.563E-7 * d);
  }

  Angle _E() {
    double E0 = M.asRad() + e * sin(M.asRad()) * (1 + e * cos(M.asRad()));
    for (var i = 0; i < 25; i++) {
      double E1 = E0 - (E0 - e * sin(E0) - M.asRad()) / (1 - e * cos(E0));
      if ((E0 - E1).abs() < rads(0.005)) {
        E0 = E1;
        break;
      } else {
        E0 = E1;
      }
    }

    if (_DEBUG) {
      print("E ${deg(E0)}");
    }

    return Angle(
      rads: E0,
    );
  }

  double _dist(RectangularCoordinate xyz) {
    return sqrt(pow(xyz.x.asRad(), 2) + pow(xyz.y.asRad(), 2));
  }

  Angle _trueAnomaly(RectangularCoordinate xyz) {
    return Angle(rads: atan2( xyz.y.asRad(), xyz.x.asRad()));
  }

  RectangularCoordinate asRect() {
    var E = _E();
    return RectangularCoordinate(
      x: Angle(rads: a * (cos(E.asRad()) - e)),
      y: Angle(rads: a * sin(E.asRad()) * sqrt(1 - pow(e, 2))),
      z: Angle.ZERO,
    );
  }

  RectangularCoordinate asEclip() {
    var xyz = asRect();
    var r = _dist(xyz);
    var v = _trueAnomaly(xyz);
    return RectangularCoordinate(
      x: Angle(rads: r * ( cos(N.asRad()) * cos(v.asRad()+w.asRad()) - sin(N.asRad()) * sin(v.asRad()+w.asRad()) * cos(i.asRad()) )),
      y: Angle(rads: r * ( sin(N.asRad()) * cos(v.asRad()+w.asRad()) + cos(N.asRad()) * sin(v.asRad()+w.asRad()) * cos(i.asRad()) )),
      z: Angle(rads: r * sin(v.asRad() + w.asRad()) * sin(i.asRad())),
    );
  }

  /**
   * This will return the rectangular coordinates of the sun
   * in a not-super-efficient way. Use with caution.
   */
  RectangularCoordinate solRect() {
    return Sol(d).asEclip();
  }

  SphericalCoordinate asSphere() {
    var xyz = asRect();
    var r = _dist(xyz);
    var v = _trueAnomaly(xyz);
    var xyzEclip = asEclip();

    if (_DEBUG) {
      var lon = Angle(rads: v.asRad() + w.asRad()).rev();
      print("x ${xyz.x.asRad()}");
      print("y ${xyz.y.asRad()}");
      print("r $r");
      print("v ${v.asDeg()}");
      print("lon ${lon.asDeg()}");
      print("xEclip ${xyzEclip.x.asRad()}");
      print("yEclip ${xyzEclip.y.asRad()}");
      print("zEclip ${xyzEclip.z.asRad()}");
    }

    if (orbitsEarth) {
      var equatorial = rotateAroundX(xyzEclip, oblecl);
      return rectToSphere(equatorial);
    } else {

      // We are working with Heliocentric coordinates (sun-centered)
      // and so we need to offset the sun to find geocentric (earth-centered).
      var xyzSol = solRect();
      if (_DEBUG) {
        print("xSol ${xyzSol.x.asRad()}");
        print("ySol ${xyzSol.y.asRad()}");
        print("zSol ${xyzSol.z.asRad()}");
      }

      var xyzGeo = RectangularCoordinate(
        x: Angle(rads: xyzSol.x.asRad() + xyzEclip.x.asRad()),
        y: Angle(rads: xyzSol.y.asRad() + xyzEclip.y.asRad()),
        z: Angle(rads: xyzSol.z.asRad() + xyzEclip.z.asRad()),
      );
      
      var equatorial = rotateAroundX(xyzGeo, oblecl);
      return rectToSphere(equatorial);
    }
  }

  PlanetaryAttributes planetaryAttributes() {

    // Heliocentric (sun-centered)
    var xyz = asRect();
    var sunR = _dist(xyz);

    // Geocentric (earth-centered)
    var geoR = asSphere().r;

    // Sun - Earth
    // var xyzSol = solRect();
    // var xyzSunEarth = RectangularCoordinate(
    //   x: Angle(rads: xyzSol.x.asRad() + xyzEclip.x.asRad()),
    //   y: Angle(rads: xyzSol.y.asRad() + xyzEclip.y.asRad()),
    //   z: Angle(rads: xyzSol.z.asRad() + xyzEclip.z.asRad()),
    // );
    var sunGeoR = s;// _dist(rotateAroundX(xyzSunEarth, oblecl));

    double phaseAngle = acos(
      (sunR * sunR + geoR * geoR - sunGeoR * sunGeoR) /
      (2 * sunR * geoR)
    );
    

    return PlanetaryAttributes(
      geocentricDistance: sunR,
      heliocentricDistance: geoR,
      elongation: Angle(rads: 0.0),
      phaseAngle: Angle(rads: phaseAngle),
      phase: 0.0,
    );
  }

  double magnitude() {
    throw UnimplementedError();
  }
}