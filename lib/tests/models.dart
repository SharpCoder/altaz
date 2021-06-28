import 'dart:math';
import 'package:test/test.dart';
import '../src/models/angle.dart';

void main() {
  test('Angle degree conversion', () {
    var angle = Angle.fromDegrees(180);
    expect(angle.asRad(), pi);
    expect(angle.asDeg(), 180);

    var angle2 = Angle(rads: pi);
    expect(angle2.asRad(), pi);
    expect(angle2.asDeg(), 180);
  });

  test('Angle to DMS', () {
    var angle = Angle.fromDegrees(18.0638889);
    var dms = angle.asDMS();
    expect(dms.degrees, 18);
    expect(dms.minutes, 3);
    expect(dms.seconds, 50);
  });

  test('Angle to HMS', () {
    var angle = Angle.fromDegrees(180.0638889);
    var hms = angle.asHMS();
    expect(hms.hours, 12);
    expect(hms.minutes, 3);
    expect(hms.seconds, 50);
  });
}
