import 'package:floor/floor.dart';
@entity
class Booking{
  @PrimaryKey(autoGenerate:true)
  final int ? id;
  final int ? booth;
  final int ? index;
  final double ? price;
  final String ? event;
  final String ? slug;
  final double ? priceExtra;
  final int  ? additionalPets;
  final int  ? additionalPetsLimits;
  final int ? wristBand;
  final String ? name;
  final bool ? available;
  final int ? wristBandCount;
  Booking({this.id,this.booth,this.name,this.price,this.event,this.slug,this.additionalPets,this.additionalPetsLimits,this.priceExtra,this.wristBand,this.available,this.wristBandCount,this.index});
}