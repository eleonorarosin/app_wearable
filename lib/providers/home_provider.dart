import 'dart:math';
//
import 'package:app_wearable/models/entities/entities.dart';
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
  late List<FootDistances> dist;
  late List<FootSteps> step;
  late List<int> weekStep;
  late double carbonPrint;
  late int fullsteps;
  late int fulldistances;
  final AppDatabase db;

  //data fetched from ezternal services
  late List<FootDistances> _dist;
  late List<FootSteps> _step;

  // selected day of data to be shown
  DateTime showDate = DateTime.now().subtract(const Duration(days: 1));

  late DateTime lastFetch;
  final ImpactService impactService;

  bool doneInit = false;

  HomeProvider(this.impactService, this.db) {
    _init();
  }

  // constructor of provider which manages the fetching of all data from the servers and then notifies the ui to build
  Future<void> _init() async {
    await _fetchAndCalculate();
    await getDataOfDay(showDate);
    doneInit = true;
    notifyListeners();
  }

  Future<DateTime?> _getLastFetch() async {
    //
    var data = await db.footDistancesDao.findAllDistances();
    if (data.isEmpty) {
      return null;
    }
    return data.last.dateTime;
  }

  Future<void> _fetchAndCalculate() async {
    lastFetch = await _getLastFetch() ??
        DateTime.now().subtract(const Duration(days: 2));
    // do nothing if already fetched
    if (lastFetch.day == DateTime.now().subtract(const Duration(days: 1)).day) {
      return;
    }
    _dist = await impactService.getDistancesFromDay(lastFetch);
    for (var element in _dist) {
      db.footDistancesDao.insertDistance(element);
    } // db add to the table

    _step = await impactService.getStepsFromDay(lastFetch);
    for (var element in _step) {
      db.footStepsDao.insertSteps(element);
    } // db add to the table
  }

  // method to trigger a new data fetching
  Future<void> refresh() async {
    await _fetchAndCalculate();
    await getDataOfDay(showDate);
  }

  // method to select only the data of the chosen day
  Future<void> getDataOfDay(DateTime showDate) async {
    // check if the day we want to show has data
    var firstDay = await db.footDistancesDao.findFirstDayInDb();
    var lastDay = await db.footDistancesDao.findLastDayInDb();
    if (showDate.isAfter(lastDay!.dateTime) ||
        showDate.isBefore(firstDay!.dateTime)) return;

    this.showDate = showDate;
    dist = await db.footDistancesDao.findDistancesbyDate(
        DateUtils.dateOnly(showDate),
        DateTime(showDate.year, showDate.month, showDate.day, 23, 59));
    step = await db.footStepsDao.findStepsbyDate(DateUtils.dateOnly(showDate),
        DateTime(showDate.year, showDate.month, showDate.day, 23, 59));
    fullsteps = sumStepsofDay(step);
    fulldistances = sumDistanceofDay(dist);

    // after selecting all data we notify all consumers to rebuild
    notifyListeners();
  }

  int? _selectedCarType = 0; // Default to Diesel car

  int? get selectedCarType => _selectedCarType;

  void setSelectedCarType(int? carType) {
    _selectedCarType = carType;
    notifyListeners();
  }
}
