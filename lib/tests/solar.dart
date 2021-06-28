import 'package:test/test.dart';
import '../src/solar.dart';

void main() {
  test('Historical position of sol', () {
    var instant = DateTime.parse("1990-04-19 00:00:00Z");
    var elements = calculatePostionOfSun(instant);
    elements.output();
  });
}
