import 'dart:math';

class Distance {
  // this class models the distance data point
  final DateTime timestamp;
  final double value;

  Distance({required this.timestamp, required this.value});
}

/*class Steps {
  // this class models the steps data point
  final DateTime timestamp;
  final double value;

  Steps({required this.timestamp, required this.value});
}
*/

class FitbitGen {
  final Random _random = Random();

  List<Distance> fetchDistance() {
    return List.generate(
        100,
        (index) => Distance(
            timestamp: DateTime.now().subtract(Duration(hours: index)),
            value: _random.nextDouble()));
  }
  /*List<Steps> fetchSteps() {
    return List.generate(
        100,
        (index) => Steps(
            timestamp: DateTime.now().subtract(Duration(hours: index)),
            value: _random.nextDouble()));
  }*/
}

class CarbonPrint {
    // this class models the steps data point
  final DateTime timestamp;
  final double value;

  CarbonPrint({required this.timestamp, required this.value});
}