//Imports that are necessary to the code generator of floor
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:app_wearable/models/daos/daos.dart';
import 'entities/entities.dart';
import 'typeConverter/dateTimeConverter.dart';

//Here, we are importing the entities and the daos of the database

//The generated code will be in database.g.dart
part 'db.g.dart';

//Here we are saying that this is the first version of the Database and it has just 1 entity, i.e., Meal.
//We also added a TypeConverter to manage the DateTime of a Meal entry, since DateTimes are not natively
//supported by Floor.
@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [FootSteps,FootDistances])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  FootStepsDao get footStepsDao;
  FootDistancesDao get footDistancesDao;
}
