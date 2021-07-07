import 'package:altaz/src/core.dart';
import 'package:test/test.dart';
import '../src/solar/sol.dart';
import '../src/solar/moon.dart';
import '../src/solar/mercury.dart';
import '../src/solar/venus.dart';

void main() {
  var instant = DateTime.parse("1990-04-19 00:00:00Z");
  var daysJulian = instantToDaysJulian(instant);
  var d = julianToDayNumber(daysJulian);

  test('Historical magnitude of venus', () {
    var venus = Venus(d);
    var mag = venus.magnitude();
    print(mag);
  });


  test('Historical position of sol', () {
    var sol = Sol(d);
    var raDec = sol.asSphere();
    print(raDec.RA.asHMS().toStr());
    print(raDec.Decl.asDMS().toStr());
  });

  test('Historical position of the moon', () {
    var moon = Moon(d);
    var raDec = moon.asSphere();
    print(raDec.RA.asHMS().toStr());
    print(raDec.Decl.asDMS().toStr());
  });

  test('Historical position of mercury', () {
    var mercury = Mercury(d);
    var raDec = mercury.asSphere();
    print(raDec.RA.asDeg());
    print(raDec.Decl.asDeg());
    print(raDec.RA.asHMS().toStr());
    print(raDec.Decl.asDMS().toStr());

  });

  test('Current position of mercury', () {
    var instant = DateTime.now().toUtc();
    var daysJulian = instantToDaysJulian(instant);
    var d = julianToDayNumber(daysJulian);
    var mercury = Mercury(d);
    var raDec = mercury.asSphere();
    print(raDec.RA.asHMS().toStr());
    print(raDec.Decl.asDMS().toStr());
  });

  test('Current position of venus', () {
    var instant = DateTime.now().toUtc();
    var daysJulian = instantToDaysJulian(instant);
    var d = julianToDayNumber(daysJulian);
    var venus = Venus(d);
    var raDec = venus.asSphere();
    print(raDec.RA.asHMS().toStr());
    print(raDec.Decl.asDMS().toStr());
  });

  test('Current magnitude of venus', () {
    var instant = DateTime.now().toUtc();
    var daysJulian = instantToDaysJulian(instant);
    var d = julianToDayNumber(daysJulian);
    var venus = Venus(d);
    var mag = venus.magnitude();
    print(mag);
  });
}
