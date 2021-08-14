import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'Booking.dart';
import 'BookingDAO.dart';

part 'Database.g.dart';

@Database(version: 1, entities: [Booking])
abstract class AppDatabase extends FloorDatabase{
  BookingDAO get bookingDao;
}