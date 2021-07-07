class TLE {
  final String name;
  final String classification;
  final int launchYear;
  final int launchNumber;
  final String launchPiece;
  final int epochYear;
  final double epochDay;
  final double meanMotionD1;
  final double meanMotionD2;
  final double dragTerm;
  final int ephemerisType;
  final int elementSetNumber;
  final int catalogNumber;
  final double inclination;
  final double rightAscension;
  final double eccentricity;
  final double argOfPerigee;
  final double meanAnomaly;
  final double meanMotion;
  final int revolutionNumber;

  TLE({
    required this.name,
    required this.classification,
    required this.launchYear,
    required this.launchNumber,
    required this.launchPiece,
    required this.epochYear,
    required this.epochDay,
    required this.meanMotionD1,
    required this.meanMotionD2,
    required this.dragTerm,
    required this.ephemerisType,
    required this.elementSetNumber,
    required this.catalogNumber,
    required this.inclination,
    required this.rightAscension,
    required this.eccentricity,
    required this.argOfPerigee,
    required this.meanAnomaly,
    required this.meanMotion,
    required this.revolutionNumber,
  });
}