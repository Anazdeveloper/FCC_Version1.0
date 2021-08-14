import 'dart:convert';

import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'Repo.dart';

class StripeRepo{
  EventDetails ? eventDetails;
  StripeRepo({this.eventDetails});

  Future clearSelection(EventDetails event) async {
    event.data!.booths!.forEach((element) {
      element.selected = null;
    });
    await clearDB();
  }

  Future clearDB() async{
    final db=await LocalDB().getLocalDB();
    await db.deleteAllBookings();
  }



  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret(
      String token,EventDetails event,String eventName, List<Map<String, dynamic>> booths, double total) async {
    final url = Uri.parse(Urls.payment);
    final pref=await Shared().getSharedStorage();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final String date = dateFormat.format(event.data!.startDate!);
    print(date);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'event': event,
        'booked_date': date,
        'total_amount': total,
        'address_id': 3,
        'booths': booths
      }),
    );
    print("booths${booths}");
    print("BodyRequest:${json.encode({
      'event': event,
      'booked_date': date,
      'total_amount': total,
      'address_id': pref.get('addr_id'),
      'booths':booths
    })}");
    print("status code:${response.statusCode}");
    print("response:${response.body}");
    if (response.statusCode == 403) {
      await RefreshToken().getData();
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'event': event,
          'booked_date': date,
          'total_amount': total,
          'address_id': pref.get("addr_id"),
          'booths': booths
        }),
      );
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getPublishableKey(String token) async {
    final url = Uri.parse(Urls.paymentConfig);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print("status code:${response.statusCode}");
    if (response.statusCode == 403) {
      await RefreshToken().getData();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }


  Future bookingStatusUpdate(String reference,String token,Map<String,dynamic> body) async{
    final url = Uri.parse(Urls.bookingUpdate+reference+"/payment");
    final response = await http.put(
        url,
        headers: {
          'Content-Type': ContentType.urlEncode,
          'Authorization': 'Bearer $token'
        },
        body: body
    );
    print("status code:${response.statusCode}");
    if (response.statusCode == 403) {
      await RefreshToken().getData();
      final response = await http.put(
          url,
          headers: {
            'Content-Type': ContentType.urlEncode,
            'Authorization': 'Bearer $token'
          },
          body: body
      );
      return json.decode(response.body);
    }
    print("Update:${json.decode(response.body)}");
    return json.decode(response.body);
  }

}