/**
 * core.dart
 * Author: Josh Cole
 * 
 * This file contains core calculations used throughout the library
 * specifically around time manipulation and angular computations.
 */
import 'models/angle.dart';

double timeToDec(double hours, double minutes, double seconds) {
  return hours + (minutes/60) + (seconds/3600);
}

Angle timeToAngle(double hours, double minutes, double seconds) {
  return Angle.fromDegrees(timeToDec(hours, minutes, seconds) * 15);
}