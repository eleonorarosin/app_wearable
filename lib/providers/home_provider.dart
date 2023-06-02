import 'dart:math';
//
import 'package:flutter/material.dart';
import 'package:app_wearable/models/db.dart';
import 'package:app_wearable/services/impact.dart';
import 'package:app_wearable/services/server_strings.dart';
import 'package:app_wearable/utils/algorithm.dart';
import 'package:app_wearable/utils/shared_preferences.dart';

// this is the change notifier. it will manage all the logic of the home page: fetching the correct data from the database
// and on startup fetching the data from the online services
class HomeProvider extends ChangeNotifier {
  // data to be used by the UI
  late List<Distance> distance;
  //late List<Steps> steps;
  late List<CarbonPrint> carbonPrint;
  //late double consumption;
  

  // data fetched from external services or db
  late List<Distance> _distanceDB;
  //late List<Steps> _stepsDB;
  late List<CarbonPrint> _carbonPrintDB;

  // selected day of data to be shown
  DateTime showDate = DateTime.now().subtract(const Duration(days: 1));

  // data generators faking external services
  final FitbitGen fitbitGen = FitbitGen();
  final Random _random = Random();

  // constructor of provider which manages the fetching of all data from the servers and then notifies the ui to build
  DateTime lastFetch = DateTime.now().subtract(Duration(days: 2));
  final ImpactService impactService;

  bool doneInit = false;

  HomeProvider(this.impactService) {
    _init();
  }
  
   Future<void> _init() async {
    await _fetchAndCalculate();
    getDataOfDay(showDate);
    doneInit = true;
    notifyListeners();
  }
  // method to fetch all data and calculate the exposure
  Future<void> _fetchAndCalculate() async{
    _distanceDB =await impactService.getDataFromDay(lastFetch);
    //_stepsDB = fitbitGen.fetchSteps();
    _calculateCarbonPrint(_distanceDB);
  }

  // method to trigger a new data fetching
  void refresh() {
    _fetchAndCalculate();
    getDataOfDay(showDate);
  }

  // method that implements the state of the art formula
  void _calculateCarbonPrint(List<Distance> dist) {
    _carbonPrintDB = getCarbonPrint(dist);
  }

  // method to select only the data of the chosen day
  void getDataOfDay(DateTime showDate) {
    this.showDate = showDate;
    distance = _distanceDB
        .where((element) => element.timestamp.day == showDate.day)
        .toList()
        .reversed
        .toList();
    /*steps = _stepsDB
        .where((element) => element.timestamp.day == showDate.day)
        .toList()
        .reversed
        .toList();*/
    /*fullprint = carbonPrint.map((e) => e.value).reduce(
          (value, element) => value + element,
        );*/
    // after selecting all data we notify all consumers to rebuild
    notifyListeners();
  }
}