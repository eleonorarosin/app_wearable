import 'package:floor/floor.dart';
import 'package:app_wearable/models/entities/entities.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class FootDistancesDao {
  //Query #0: SELECT -> this allows to obtain all the entries of the HR table of a certain date
  @Query('SELECT * FROM FootDistances WHERE dateTime between :startTime and :endTime ORDER BY dateTime ASC')
  Future<List<FootDistances>> findDistancesbyDate(DateTime startTime, DateTime endTime);
  
  /*Future<int> findDistancesbyDate(DateTime startTime, DateTime endTime) async {
  final List<FootDistances> distList = await _findDistancesbyDate(startTime, endTime);
  int sum = 0;
  for (final dist in distList) {
    sum += dist.value;
  }
  return sum;
  }*/
  /*Future<List<FootDistances>> findDistancesbyDate(DateTime startTime, DateTime endTime) async {
  final List<FootDistances> distList = await _findDistancesbyDate(startTime, endTime);
  int sum = 0;
  for (final dist in distList) {
    sum += dist.value;
  }
  return [distList, sum];
}*/


  //Query #1: SELECT -> this allows to obtain all the entries of the HR table
  @Query('SELECT * FROM FootDistances')
  Future<List<FootDistances>> findAllDistances();

  //Query #2: INSERT -> this allows to add a Distance in the table
  @insert
  Future<void> insertDistance(FootDistances dist);

  //Query #3: DELETE -> this allows to delete a HR from the table
  @delete
  Future<void> deleteDistance(FootDistances dist);

  //Query #4: UPDATE -> this allows to update a HR entry
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateDistance(FootDistances dist);

   @Query('SELECT * FROM FootDistances ORDER BY dateTime ASC LIMIT 1')
  Future<FootDistances?> findFirstDayInDb();

  @Query('SELECT * FROM FootDistances ORDER BY dateTime DESC LIMIT 1')
  Future<FootDistances?> findLastDayInDb();
}//DistancesDao