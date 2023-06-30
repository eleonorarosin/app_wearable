import 'dart:math';
import 'package:app_wearable/models/entities/entities.dart';
import 'package:app_wearable/models/db.dart';

int sumStepsofDay(List<FootSteps> footsteps) {
  //final List<FootSteps> stepsList =[];
  int sum = 0;
  for (FootSteps steps in footsteps) {
    sum += steps.value;
  }
  return sum;
}

/*Future<List<int>> getSumStepsForLast7Days(DateTime dateOnly, DateTime dateTime) async {
  final DateTime today = DateTime.now();
  final DateTime endDate = DateTime(today.year, today.month, today.day);
  final DateTime startDate = endDate.subtract(const Duration(days: 7));
  
  final List<FootSteps> stepsList = [];
  
  final List<int> sumStepsList = [];
  for (int i = 0; i < 7; i++) {
    final DateTime currentDate = startDate.add(Duration(days: i));
    int sumSteps = 0;
    for (final steps in stepsList) {
      if (steps.dateTime.year == currentDate.year &&
          steps.dateTime.month == currentDate.month &&
          steps.dateTime.day == currentDate.day) {
        sumSteps += steps.value;
      }
    }
    sumStepsList.add(sumSteps);
  }
  
  return sumStepsList;
}*/

int sumDistanceofDay(List<FootDistances> footdistances) {
  //final List<FootSteps> stepsList =[];
  int sum = 0;
  for (FootDistances distances in footdistances) {
    sum += distances.value;
  }
  return sum;
}
