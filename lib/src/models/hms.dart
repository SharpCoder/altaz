class HMS {
  final double hours;
  final double minutes;
  final double seconds;

  HMS({required this.hours, required this.minutes, required this.seconds});

  String toStr() {
    return '${hours}h ${minutes}m ${seconds}s';
  }
}
