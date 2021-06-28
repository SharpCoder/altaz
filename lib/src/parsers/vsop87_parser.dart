/**
 * vsop87_parser.dart
 * Author: Josh Cole
 * 
 * This file is specifically dedicated to parsing the raw text of
 * the vsop87_flat.csv output from my other repo.
*/
import '../models/vsop87_term.dart';

List<VSOP87Term> parse_vsop87(String rawText) {
  List<VSOP87Term> results = List.empty(growable: true);
  var lines = rawText.split('\n');
  for (var line in lines) {
    if (line.length < 10) continue;
    var components = line.split(',');
    results.add(VSOP87Term(
      planet: components[0],
      version: int.parse(components[1]),
      variable: components[2],
      term: int.parse(components[3]),
      A: double.parse(components[4]),
      B: double.parse(components[5]),
      C: double.parse(components[6]),
    ));
  }
  return results;
}
