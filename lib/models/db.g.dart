// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FootStepsDao? _footStepsDaoInstance;

  FootDistancesDao? _footDistancesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FootSteps` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `value` INTEGER NOT NULL, `dateTime` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FootDistances` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `value` INTEGER NOT NULL, `dateTime` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FootStepsDao get footStepsDao {
    return _footStepsDaoInstance ??= _$FootStepsDao(database, changeListener);
  }

  @override
  FootDistancesDao get footDistancesDao {
    return _footDistancesDaoInstance ??=
        _$FootDistancesDao(database, changeListener);
  }
}

class _$FootStepsDao extends FootStepsDao {
  _$FootStepsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _footStepsInsertionAdapter = InsertionAdapter(
            database,
            'FootSteps',
            (FootSteps item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'dateTime': _dateTimeConverter.encode(item.dateTime)
                }),
        _footStepsUpdateAdapter = UpdateAdapter(
            database,
            'FootSteps',
            ['id'],
            (FootSteps item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'dateTime': _dateTimeConverter.encode(item.dateTime)
                }),
        _footStepsDeletionAdapter = DeletionAdapter(
            database,
            'FootSteps',
            ['id'],
            (FootSteps item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'dateTime': _dateTimeConverter.encode(item.dateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FootSteps> _footStepsInsertionAdapter;

  final UpdateAdapter<FootSteps> _footStepsUpdateAdapter;

  final DeletionAdapter<FootSteps> _footStepsDeletionAdapter;

  @override
  Future<List<FootSteps>> findStepsbyDate(
    DateTime startTime,
    DateTime endTime,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FootSteps WHERE dateTime between ?1 and ?2 ORDER BY dateTime ASC',
        mapper: (Map<String, Object?> row) => FootSteps(row['id'] as int?, row['value'] as int, _dateTimeConverter.decode(row['dateTime'] as int)),
        arguments: [
          _dateTimeConverter.encode(startTime),
          _dateTimeConverter.encode(endTime)
        ]);
  }

  @override
  Future<List<FootSteps>> findAllSteps() async {
    return _queryAdapter.queryList('SELECT * FROM FootSteps',
        mapper: (Map<String, Object?> row) => FootSteps(
            row['id'] as int?,
            row['value'] as int,
            _dateTimeConverter.decode(row['dateTime'] as int)));
  }

  @override
  Future<List<FootSteps>> findStepsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FootSteps WHERE DATE(dateTime) BETWEEN DATE(?1, \"-7 days\") AND ?2 ORDER BY dateTime ASC',
        mapper: (Map<String, Object?> row) => FootSteps(row['id'] as int?, row['value'] as int, _dateTimeConverter.decode(row['dateTime'] as int)),
        arguments: [
          _dateTimeConverter.encode(startDate),
          _dateTimeConverter.encode(endDate)
        ]);
  }

  @override
  Future<void> insertSteps(FootSteps steps) async {
    await _footStepsInsertionAdapter.insert(steps, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSteps(FootSteps steps) async {
    await _footStepsUpdateAdapter.update(steps, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteSteps(FootSteps steps) async {
    await _footStepsDeletionAdapter.delete(steps);
  }
}

class _$FootDistancesDao extends FootDistancesDao {
  _$FootDistancesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _footDistancesInsertionAdapter = InsertionAdapter(
            database,
            'FootDistances',
            (FootDistances item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'dateTime': _dateTimeConverter.encode(item.dateTime)
                }),
        _footDistancesUpdateAdapter = UpdateAdapter(
            database,
            'FootDistances',
            ['id'],
            (FootDistances item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'dateTime': _dateTimeConverter.encode(item.dateTime)
                }),
        _footDistancesDeletionAdapter = DeletionAdapter(
            database,
            'FootDistances',
            ['id'],
            (FootDistances item) => <String, Object?>{
                  'id': item.id,
                  'value': item.value,
                  'dateTime': _dateTimeConverter.encode(item.dateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FootDistances> _footDistancesInsertionAdapter;

  final UpdateAdapter<FootDistances> _footDistancesUpdateAdapter;

  final DeletionAdapter<FootDistances> _footDistancesDeletionAdapter;

  @override
  Future<List<FootDistances>> findDistancesbyDate(
    DateTime startTime,
    DateTime endTime,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FootDistances WHERE dateTime between ?1 and ?2 ORDER BY dateTime ASC',
        mapper: (Map<String, Object?> row) => FootDistances(row['id'] as int?, row['value'] as int, _dateTimeConverter.decode(row['dateTime'] as int)),
        arguments: [
          _dateTimeConverter.encode(startTime),
          _dateTimeConverter.encode(endTime)
        ]);
  }

  @override
  Future<List<FootDistances>> findAllDistances() async {
    return _queryAdapter.queryList('SELECT * FROM FootDistances',
        mapper: (Map<String, Object?> row) => FootDistances(
            row['id'] as int?,
            row['value'] as int,
            _dateTimeConverter.decode(row['dateTime'] as int)));
  }

  @override
  Future<FootDistances?> findFirstDayInDb() async {
    return _queryAdapter.query(
        'SELECT * FROM FootDistances ORDER BY dateTime ASC LIMIT 1',
        mapper: (Map<String, Object?> row) => FootDistances(
            row['id'] as int?,
            row['value'] as int,
            _dateTimeConverter.decode(row['dateTime'] as int)));
  }

  @override
  Future<FootDistances?> findLastDayInDb() async {
    return _queryAdapter.query(
        'SELECT * FROM FootDistances ORDER BY dateTime DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => FootDistances(
            row['id'] as int?,
            row['value'] as int,
            _dateTimeConverter.decode(row['dateTime'] as int)));
  }

  @override
  Future<void> insertDistance(FootDistances dist) async {
    await _footDistancesInsertionAdapter.insert(dist, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDistance(FootDistances dist) async {
    await _footDistancesUpdateAdapter.update(dist, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteDistance(FootDistances dist) async {
    await _footDistancesDeletionAdapter.delete(dist);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
