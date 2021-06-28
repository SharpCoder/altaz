class VSOP87Term {
  final String planet;
  final int version;
  final String variable;
  final int term;
  final double A;
  final double B;
  final double C;

  VSOP87Term({
    required this.planet,
    required this.version,
    required this.variable,
    required this.term,
    required this.A,
    required this.B,
    required this.C,
  });
}
