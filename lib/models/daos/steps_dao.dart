import 'package:floor/floor.dart';
import 'package:app_wearable/models/entities/entities.dart';
import 'package:sqflite/sqflite.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class FootStepsDao {
  //Query #0: SELECT -> this allows to obtain the sum of all the entries of the Step table of a certain date
  @Query('SELECT * FROM FootSteps WHERE dateTime between :startTime and :endTime ORDER BY dateTime ASC')
  Future<List<FootSteps>> findStepsbyDate(DateTime startTime, DateTime endTime);

  //Query #1: SELECT -> this allows to obtain all the entries of the Step table
  @Query('SELECT * FROM FootSteps')
  Future<List<FootSteps>> findAllSteps();

  //Query #2: INSERT -> this allows to add a Step in the table
  @insert
  Future<void> insertSteps(FootSteps steps);

  //Query #3: DELETE -> this allows to delete a Step from the table
  @delete
  Future<void> deleteSteps(FootSteps steps);

  //Query #4: UPDATE -> this allows to update a Step entry
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateSteps(FootSteps steps);

  //Query #5 SELECT -> this allow to obtain the last week entries of the Step table and to sum them by day
  @Query('SELECT * FROM FootSteps WHERE DATE(dateTime) BETWEEN DATE(:startDate, "-7 days") AND :endDate ORDER BY dateTime ASC')
  Future<List<FootSteps>> findStepsByDateRange(DateTime startDate, DateTime endDate);

  /*Future<List<int>> getSumStepsForLast7Days(DateTime dateOnly, DateTime dateTime) async {
  final DateTime today = DateTime.now();
  final DateTime endDate = DateTime(today.year, today.month, today.day);
  final DateTime startDate = endDate.subtract(const Duration(days: 7));
  
  final List<FootSteps> stepsList = await _findStepsByDateRange(startDate, endDate);
  
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

}//StepsDao