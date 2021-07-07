import 'dart:math';
import '../models/tle.dart';

double parseScientificDouble(String input) {
  bool negative = false;
  bool exponentFound = false;

  double base = 0.0;
  int baseLength = 0;

  double exponent = 0.0;

  for (int i = 0; i < input.length; i++) {
    var c = input[i];
    if (i == 0 && c == '-') {
      negative = true;
    } else if (i == 0 && c == ' ') {
      continue;
    } else if (c == '-') {
      // Scientific exponent
      exponentFound = true;
    } else if (exponentFound) {
      exponent = (exponent * 10) + int.parse(c);
    } else {
      base = (base * 10) + int.parse(c);
      baseLength++;
    }
  }
  
  double result = (base / pow(10,baseLength)) * pow(10, -exponent );
  if (negative) {
    result = result.abs() * -1;
  }
  return result;
}

List<TLE> parseTLEs(String text) {
  var lines = text.split('\n');
  var results = List<TLE>.empty(growable: true);

  for (int i = 0; i < lines.length; i+=3) {
    try {
      var line0 = lines[i];
      var line1 = lines[i+1];
      var line2 = lines[i+2];

      results.add(TLE(
        name: line0.trim(),
        catalogNumber: int.parse(line1.substring(2, 7)),
        classification: line1.substring(7, 8),
        launchYear: int.parse(line1.substring(9, 11)),
        launchNumber: int.parse(line1.substring(11, 14)),
        launchPiece: line1.substring(14,17).trim(),
        epochYear: int.parse(line1.substring(18, 20)),
        epochDay: double.parse(line1.substring(20, 32)),
        meanMotionD1: double.parse(line1.substring(33, 43)),
        meanMotionD2: parseScientificDouble(line1.substring(44, 52)),
        dragTerm: parseScientificDouble(line1.substring(53, 61)),
        ephemerisType: int.tryParse(line1.substring(62, 63)) ?? 0,
        elementSetNumber: int.parse(line1.substring(64, 68)),
        inclination: double.parse(line2.substring(8, 16)),
        rightAscension: double.parse(line2.substring(17, 25)),
        eccentricity: double.parse(line2.substring(26, 33)),
        argOfPerigee: double.parse(line2.substring(34, 42)),
        meanAnomaly: double.parse(line2.substring(43, 51)),
        meanMotion: double.parse(line2.substring(52, 63)),
        revolutionNumber: int.parse(line2.substring(63, 68)),
      ));
    } catch (ex) {
      print(ex);
      print("ERROR PARSING TLE");
    }
  }

  return results;
}