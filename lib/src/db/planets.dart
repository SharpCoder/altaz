/**
 * db.planets.dart
 * Author: Josh Cole
 * 
 * This file contains all the planetary coefficients for the major planets.
*/
import 'dart:core';
import '../models/planetary_coefficients.dart';

/* 
NOTE!!!! THIS IS ALL IN DEGREES!! NOT RADIANS!!! 
Consider using proper Angle objects. Although that'll be a PITA.
*/
var Sun = PlanetaryCoefficients(
    name: "SUN",
    longitudeOfAscendingNode: [],
    inclination: [],
    argumentOfPerihelion: [282.9404, 4.70935E-5],
    semimajorAxis: [1.00000],
    eccentricity: [0.016709, -1.151E-9],
    meanAnomaly: [356.047, 0.9856002585]);

var Moon = PlanetaryCoefficients(
    name: "MOON",
    longitudeOfAscendingNode: [125.1228, -0.0529538083],
    inclination: [5.1454],
    argumentOfPerihelion: [318.0634, 0.1643573223],
    semimajorAxis: [60.2666],
    eccentricity: [0.054900],
    meanAnomaly: [115.3654, 13.0649929509]);

var Mercury = PlanetaryCoefficients(
    name: "MERCURY",
    longitudeOfAscendingNode: [48.3313, 3.24587E-5],
    inclination: [7.0047, 5.00E-8],
    argumentOfPerihelion: [29.1241, 1.01444E-5],
    semimajorAxis: [0.387098],
    eccentricity: [0.205635, 5.59E-10],
    meanAnomaly: [168.6562, 4.0923344368]);

var Venus = PlanetaryCoefficients(
    name: "VENUS",
    longitudeOfAscendingNode: [76.6799, 2.46590E-5],
    inclination: [3.3946, 2.75E-8],
    argumentOfPerihelion: [54.8910, 1.38374E-5],
    semimajorAxis: [0.723330],
    eccentricity: [0.006773, -1.302E-9],
    meanAnomaly: [48.0052, 1.6021302244]);

var Mars = PlanetaryCoefficients(
    name: "MARS",
    longitudeOfAscendingNode: [49.5574, 2.11081E-5],
    inclination: [1.8497, -1.78E-8],
    argumentOfPerihelion: [286.5016, 2.92961E-5],
    semimajorAxis: [1.523688],
    eccentricity: [0.093405, 2.516E-9],
    meanAnomaly: [18.6021, 0.5240207766]);

var Jupiter = PlanetaryCoefficients(
    name: "JUPITER",
    longitudeOfAscendingNode: [100.4542, 2.76854E-5],
    inclination: [1.3030, -1.557E-7],
    argumentOfPerihelion: [273.8777, 1.64505E-5],
    semimajorAxis: [5.20256],
    eccentricity: [0.048498, 4.469E-9],
    meanAnomaly: [19.8950, 0.0830853001]);
