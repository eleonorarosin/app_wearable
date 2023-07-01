import 'dart:math';
import 'package:app_wearable/models/entities/entities.dart';
import 'package:app_wearable/models/db.dart';

int sumStepsofDay(List<FootSteps> footsteps) {
  int sum = 0;
  for (FootSteps steps in footsteps) {
    sum += steps.value;
  }
  return sum;
}

int sumDistanceofDay(List<FootDistances> footdistances) {
  //final List<FootSteps> stepsList =[];
  int sum = 0;
  for (FootDistances distances in footdistances) {
    sum += distances.value;
  }
  return sum;
}

List<FootSteps> calculateStepsSumByInterval(List<FootSteps> stepsList) {
  // Creo un oggetto Map per tenere traccia delle somme dei passi per ogni intervallo di tre ore
  Map<DateTime, int> stepsSumMap = {};

  // Itero attraverso la lista di passi e accumulo la somma dei passi per ogni intervallo di tre ore
  for (FootSteps step in stepsList) {
    // Tronco l'ora al multiplo di tre ore inferiore
    DateTime roundedTime = DateTime(step.dateTime.year, step.dateTime.month, step.dateTime.day, step.dateTime.hour - (step.dateTime.hour % 3), 0, 0);

        stepsSumMap[roundedTime] = (stepsSumMap[roundedTime] ?? 0) + step.value;

  }

  // Creo la lista di oggetti FootSteps contenenti la somma dei passi e le ore corrispondenti
  List<FootSteps> result = stepsSumMap.entries.map((entry) {
    DateTime intervalTime = entry.key;
    int stepsSum = entry.value;

    return FootSteps(null, stepsSum, intervalTime);
  }).toList();

  return result;
}
