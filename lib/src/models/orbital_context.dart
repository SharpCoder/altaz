import 'xyz.dart';
import 'angle.dart';
import 'heliocentric_coordinate.dart';
import 'spherical_coordinate.dart';

class OrbitalContext {
  XYZ? xyz;
  XYZ? xyzEquat;
  Angle? longitude;
  Angle? latitude;
  double? r;
  HeliocentricCoordinate? heliocentricCoordinates;
  SphericalCoordinate? sphericalCoordinates;

  OrbitalContext({
    this.xyz,
    this.xyzEquat,
    this.longitude,
    this.latitude,
    this.r,
    this.heliocentricCoordinates,
    this.sphericalCoordinates,
  });

  void output() {
    print("X ${this.xyz?.X.asDeg()}");
    print("Y ${this.xyz?.Y.asDeg()}");
    print("Z ${this.xyz?.Z.asDeg()}");
    print("Xequat ${this.xyzEquat?.X.asRad()}");
    print("Yequat ${this.xyzEquat?.Y.asRad()}");
    print("Zequat ${this.xyzEquat?.Z.asRad()}");
    print("lon ${this.longitude?.asDeg()}");
    print("lat ${this.latitude?.asDeg()}");
    print("RA ${this.sphericalCoordinates?.ra.asHMS().toStr()}");
    print("DEC ${this.sphericalCoordinates?.dec.asDMS().toStr()}");
    print("r ${this.r}");
  }
}
