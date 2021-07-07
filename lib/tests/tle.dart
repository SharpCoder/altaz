import 'dart:math';
import 'dart:io';
import '../src/tle/parser.dart';
import 'package:test/test.dart';

void main() {
  test("FORTRAN scientific notation parsing", () {
    var dbl = parseScientificDouble("-123456-6");
    expect(dbl, -0.123456 * pow(10, -6));
  });

  test("TLE Parsing", () {
    var text = File("lib/tests/tle.txt").readAsStringSync();
    print(text);
    var tles = parseTLEs(text);
    expect(tles.length, 3);
  });
}