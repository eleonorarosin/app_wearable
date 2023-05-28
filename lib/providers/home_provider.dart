import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app_wearable/models/db.dart';

// this is the change notifier. it will manage all the logic of the home page: fetching the correct data from the database
// and on startup fetching the data from the online services
class HomeProvider extends ChangeNotifier {
  // data to be used by the UI
  late List<Distance> distance;
  late List<Steps> steps;
  late List<CarbonPrint> carbonPrint;
  late double fullprint;
  //late double consumption;
  

  // data fetched from external services or db
  late List<Distance> _distanceDB;
  late List<Steps> _stepsDB;
  late List<CarbonPrint> _carbonPrintDB;

  // selected day of data to be shown
  DateTime showDate = DateTime.now();

  // data generators faking external services
  final FitbitGen fitbitGen = FitbitGen();
  final Random _random = Random();

  // constructor of provider which manages the fetching of all data from the servers and then notifies the ui to build
  HomeProvider() {
    _fetchAndCalculate();
    getDataOfDay(showDate);
  }

  // method to fetch all data and calculate the exposure
  void _fetchAndCalculate() {
    _distanceDB = fitbitGen.fetchDistance();
    _stepsDB = fitbitGen.fetchSteps();
    _calculateCarbonPrint();
  }

  // method to trigger a new data fetching
  void refresh() {
    _fetchAndCalculate();
    getDataOfDay(showDate);
  }

  // method that implements the state of the art formula
  void _calculateCarbonPrint() {
    _carbonPrintDB = List.generate(
        100,
        (index) => CarbonPrint(
            value: _distanceDB[index].value ,/** consumption,*/
            timestamp: DateTime.now().subtract(Duration(hours: index))));
  }

  // method to select only the data of the chosen day
  void getDataOfDay(DateTime showDate) {
    this.showDate = showDate;
    distance = _distanceDB
        .where((element) => element.timestamp.day == showDate.day)
        .toList()
        .reversed
        .toList();
    steps = _stepsDB
        .where((element) => element.timestamp.day == showDate.day)
        .toList()
        .reversed
        .toList();
    /*fullprint = carbonPrint.map((e) => e.value).reduce(
          (value, element) => value + element,
        );*/
    // after selecting all data we notify all consumers to rebuild
    notifyListeners();
  }
}