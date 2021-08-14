// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

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

  BookingDAO? _bookingDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
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
            'CREATE TABLE IF NOT EXISTS `Booking` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `booth` INTEGER, `index` INTEGER, `price` REAL, `event` TEXT, `slug` TEXT, `priceExtra` REAL, `additionalPets` INTEGER, `additionalPetsLimits` INTEGER, `wristBand` INTEGER, `name` TEXT, `available` INTEGER, `wristBandCount` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BookingDAO get bookingDao {
    return _bookingDaoInstance ??= _$BookingDAO(database, changeListener);
  }
}

class _$BookingDAO extends BookingDAO {
  _$BookingDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _bookingInsertionAdapter = InsertionAdapter(
            database,
            'Booking',
            (Booking item) => <String, Object?>{
                  'id': item.id,
                  'booth': item.booth,
                  'index': item.index,
                  'price': item.price,
                  'event': item.event,
                  'slug': item.slug,
                  'priceExtra': item.priceExtra,
                  'additionalPets': item.additionalPets,
                  'additionalPetsLimits': item.additionalPetsLimits,
                  'wristBand': item.wristBand,
                  'name': item.name,
                  'available':
                      item.available == null ? null : (item.available! ? 1 : 0),
                  'wristBandCount': item.wristBandCount
                }),
        _bookingUpdateAdapter = UpdateAdapter(
            database,
            'Booking',
            ['id'],
            (Booking item) => <String, Object?>{
                  'id': item.id,
                  'booth': item.booth,
                  'index': item.index,
                  'price': item.price,
                  'event': item.event,
                  'slug': item.slug,
                  'priceExtra': item.priceExtra,
                  'additionalPets': item.additionalPets,
                  'additionalPetsLimits': item.additionalPetsLimits,
                  'wristBand': item.wristBand,
                  'name': item.name,
                  'available':
                      item.available == null ? null : (item.available! ? 1 : 0),
                  'wristBandCount': item.wristBandCount
                }),
        _bookingDeletionAdapter = DeletionAdapter(
            database,
            'Booking',
            ['id'],
            (Booking item) => <String, Object?>{
                  'id': item.id,
                  'booth': item.booth,
                  'index': item.index,
                  'price': item.price,
                  'event': item.event,
                  'slug': item.slug,
                  'priceExtra': item.priceExtra,
                  'additionalPets': item.additionalPets,
                  'additionalPetsLimits': item.additionalPetsLimits,
                  'wristBand': item.wristBand,
                  'name': item.name,
                  'available':
                      item.available == null ? null : (item.available! ? 1 : 0),
                  'wristBandCount': item.wristBandCount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Booking> _bookingInsertionAdapter;

  final UpdateAdapter<Booking> _bookingUpdateAdapter;

  final DeletionAdapter<Booking> _bookingDeletionAdapter;

  @override
  Future<List<Booking>> findBookings() async {
    return _queryAdapter.queryList('SELECT * from Booking',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as int?,
            booth: row['booth'] as int?,
            name: row['name'] as String?,
            price: row['price'] as double?,
            event: row['event'] as String?,
            slug: row['slug'] as String?,
            additionalPets: row['additionalPets'] as int?,
            additionalPetsLimits: row['additionalPetsLimits'] as int?,
            priceExtra: row['priceExtra'] as double?,
            wristBand: row['wristBand'] as int?,
            available: row['available'] == null
                ? null
                : (row['available'] as int) != 0,
            wristBandCount: row['wristBandCount'] as int?,
            index: row['index'] as int?));
  }

  @override
  Future<List<Booking>> deleteAllBookings() async {
    return _queryAdapter.queryList('delete from Booking',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as int?,
            booth: row['booth'] as int?,
            name: row['name'] as String?,
            price: row['price'] as double?,
            event: row['event'] as String?,
            slug: row['slug'] as String?,
            additionalPets: row['additionalPets'] as int?,
            additionalPetsLimits: row['additionalPetsLimits'] as int?,
            priceExtra: row['priceExtra'] as double?,
            wristBand: row['wristBand'] as int?,
            available: row['available'] == null
                ? null
                : (row['available'] as int) != 0,
            wristBandCount: row['wristBandCount'] as int?,
            index: row['index'] as int?));
  }

  @override
  Future<int> insertBooking(Booking booking) {
    return _bookingInsertionAdapter.insertAndReturnId(
        booking, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateBooking(Booking booking) {
    return _bookingUpdateAdapter.updateAndReturnChangedRows(
        booking, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteBooking(Booking booking) {
    return _bookingDeletionAdapter.deleteAndReturnChangedRows(booking);
  }
}
