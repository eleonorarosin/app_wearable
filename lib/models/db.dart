import 'dart:math';

class Distance {
  // this class models the single heart rate data point
  final DateTime timestamp;
  final double value;

  Distance({required this.timestamp, required this.value});
}

class Walk {
  // this class models the single PM2.5 data point
  final DateTime timestamp;
  final double value;

  Walk({required this.timestamp, required this.value});
}


class FitbitGen {
  final Random _random = Random();

  List<Distance> fetchDistance() {
    return List.generate(
        100,
        (index) => Distance(
            timestamp: DateTime.now().subtract(Duration(hours: index)),
            value: _random.nextDouble()));
  }
  List<Walk> fetchWalk() {
    return List.generate(
        100,
        (index) => Walk(
            timestamp: DateTime.now().subtract(Duration(hours: index)),
            value: _random.nextDouble()));
  }
}

/*class CarbonPrint {
  final Random _random = Random();
  List<Distance> fetchPM() {
    return List.generate(
        100,
        (index) => Distance(
            timestamp: DateTime.now().subtract(Duration(hours: index)),
            value: _random.nextInt(1000)));
  }

}*/