import 'package:floor/floor.dart';

import 'Booking.dart';

@dao
abstract class BookingDAO {
  @Query("SELECT * from Booking")
  Future<List<Booking>> findBookings();

  @Query("delete from Booking")
  Future<List<Booking>> deleteAllBookings();

  @insert
  Future<int> insertBooking(Booking booking);

  @delete
  Future<int> deleteBooking(Booking booking);

  @update
  Future<int> updateBooking(Booking booking);

}