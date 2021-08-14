import 'dart:convert';
import 'dart:io';

import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Screens/BookingPage/BookingPage.dart';
import 'package:first_class_canine_demo/Screens/BookingPage/BookingPageBLOC.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePage.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePageBloc.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/LoadingButton.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/CanineSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:stripe_platform_interface/stripe_platform_interface.dart';

import 'ConnectivityCheck.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final List<Map<String, dynamic>> booths;
  final String event;
  final EventDetails eventDetails;
  final dynamic kennelName;

  PaymentScreen(
      this.total, this.booths, this.event, this.eventDetails, this.kennelName);

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  CardFieldInputDetails? _card;
  bool? _saveCard = false;
  bool isPaying = false;

  @override
  void initState() {
    super.initState();
    ConnectivityCheck().checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    //  final blocProvider=BlocProvider.of<StripePaymentBLOC>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CanineText(
          text: "Payment",
          color: CanineColors.textColor,
        ),
        elevation: 0.0,
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              if (isPaying == false) {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          if (isPaying == true) {
            return false;
          }
          return true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: CardField(
                cursorColor: CanineColors.Primary,
                style: TextStyle(),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                numberHintText: "Card number",
                autofocus: true,
                onCardChanged: (card) {
                  setState(() {
                    _card = card;
                  });
                },
              ),
            ),
            /*CheckboxListTile(
              value: _saveCard,
              onChanged: (value) {
                setState(() {
                  _saveCard = value;
                });
              },
              title: Text(
                'Save card during payment',
                style: TextStyle(color: CanineColors.Primary),
              ),
            ),*/
            Padding(
              padding: EdgeInsets.all(16),
              child: LoadingButton(
                onPressed:
                    _card?.complete == true ? _handlePayPress : showWarning,
                text: 'Pay',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showWarning() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: CanineText(
        text: "Invalid card details!",
        maxLines: 10,
      ),
    ));
  }

  Future<void> _handlePayPress() async {
    if (_card == null) {
      return;
    }
    try {
      isPaying = true;
      FocusScope.of(context).unfocus();
      final pref = await Shared().getSharedStorage();
      final cartResponse = await EventsRepo("").getCart();
      if (cartResponse['status'] == true) {
        if (cartResponse['data']['slots'] != null) {
          if (cartResponse['data']['slots'].length > 0) {
            final pubResponse =
                await getPublishableKey(pref.get("user_token").toString());
            print(pubResponse);
            if (pubResponse['status'] == true) {
              if (pubResponse['data']['stripe'] != null) {
                Stripe.publishableKey =
                    pubResponse['data']['stripe']['PUB_KEY'];
              }
            }
            final clientSecret = await fetchPaymentIntentClientSecret(
                pref.get("user_token").toString());
            final billingDetails = BillingDetails();
            if (clientSecret['status'] == true) {
              if (clientSecret['data']['payment'] != null) {
                if (clientSecret['data']['payment']['secret'] != null) {
                  try {
                    final paymentIntent =
                        await Stripe.instance.confirmPaymentMethod(
                      clientSecret['data']['payment']['secret'],
                      PaymentMethodParams.card(
                        billingDetails:billingDetails,
                        setupFutureUsage: _saveCard == true
                            ? PaymentIntentsFutureUsage.OffSession
                            : null,
                      ),
                    );
                    print("PaymentStatus:${paymentIntent.status.index}");
                    if (paymentIntent.status.index == 0) {
                      final bookingStatus = await bookingStatusUpdate(
                          clientSecret['data']['reference'],
                          pref.get("user_token").toString(),
                          {"status": "paid"});
                      if (bookingStatus['status'] == true) {
                        final cartClearResponse =
                            await clearCart(pref.getString("user_token")!);
                        if (cartClearResponse['status'] == true) {
                          //Navigator.pop(context);
                          successDialog(
                              context, clientSecret['data']['reference']);
                        } else {
                          //Navigator.pop(context);
                          isPaying = false;
                          showSnackBarPayment(context);
                        }
                      } else {
                        //Navigator.pop(context);
                        isPaying = false;
                        showSnackBarPayment(context);
                        errorDialog(context);
                      }
                    } else {
                      final bookingStatus = await bookingStatusUpdate(
                          clientSecret['data']['reference'],
                          pref.get("user_token").toString(),
                          {"status": "failed"});
                      if (bookingStatus['status'] == true) {
                        //Navigator.pop(context);
                        isPaying = false;
                        showSnackBarPayment(context);
                      } else {
                        //Navigator.pop(context);
                        isPaying = false;
                        showSnackBarPayment(context);
                        errorDialog(context);
                      }
                    }
                  } catch (e) {
                    print(e);
                    final bookingStatus = await bookingStatusUpdate(
                        clientSecret['data']['reference'],
                        pref.get("user_token").toString(),
                        {"status": "failed"});

                    if (bookingStatus['status'] == true) {
                      showSnackBarPayment(context);
                      isPaying = false;
                    } else {
                      //Navigator.pop(context);
                      isPaying = false;
                      showSnackBarPayment(context);
                      errorDialog(context);
                    }
                  }
                  //await paymentDialog(context);
                }
              }
            } else {
              isPaying = false;
              /*      CanineSnackBar.show(context, "Payment failed");*/
              errorDialog(context);
            }
          }
        } else {
          await clearDB();
          await clearSelection(widget.eventDetails);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
                  content: CanineText(
                text: "Booth selection expired!",
              )))
              .closed
              .then((value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => BookingBLOC(),
                      child: BookingPage(
                        eventData: widget.eventDetails,
                      ),
                    ),
                  )));
          //CanineSnackBar.show(context,"Cart expired!");
          print("cart expired");
        }
      } else {
        showSnackBarPayment(context);
        print("cart not expired");
        isPaying = false;
      }
    } on SocketException {
      showSnackBarPayment(context);
      errorDialog(context);
    } on HttpException {
      showSnackBarPayment(context);
      errorDialog(context);
    } catch (e) {
      print("PaymentError:$e");
      isPaying = false;
      showSnackBarPayment(context);
    }
  }

  Future clearSelection(EventDetails event) async {
    event.data!.booths!.forEach((element) {
      element.selected = null;
    });
  }

  Future clearDB() async {
    final db = await LocalDB().getLocalDB();
    await db.deleteAllBookings();
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret(
      String token) async {
    final url = Uri.parse(Urls.payment);
    final pref = await Shared().getSharedStorage();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final String date = dateFormat.format(widget.eventDetails.data!.startDate!);
    print(date);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'event': widget.event,
        'kennel_name': widget.kennelName,
        'booked_date': date,
        'total_amount': widget.total,
        'address_id': pref.get('addr_id'),
        'booths': widget.booths
      }),
    );

    //for printing only
    print("booths${widget.booths}");
    print("BodyRequest:${json.encode({
          'event': widget.event,
          'kennel_name': widget.kennelName,
          'booked_date': date,
          'total_amount': widget.total,
          'address_id': pref.get('addr_id'),
          'booths': widget.booths
        })}");
    print("status code:${response.statusCode}");
    print("response:${response.body}");

    if (response.statusCode == 403) {
      await RefreshToken().getData();
      final userToken = pref.getString("user_token");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken'
        },
        body: json.encode({
          'event': widget.event,
          'booked_date': date,
          'total_amount': widget.total,
          'address_id': pref.get("addr_id"),
          'booths': widget.booths
        }),
      );
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getPublishableKey(String token) async {
    final pref = await Shared().getSharedStorage();
    final url = Uri.parse(Urls.paymentConfig);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print("status code:${response.statusCode}");
    print("Data:${json.decode(response.body)}");

    if (response.statusCode == 403) {
      await RefreshToken().getData();
      final userToken = pref.getString("user_token");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken'
        },
      );
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }

  Future bookingStatusUpdate(
      String reference, String token, Map<String, dynamic> body) async {
    final pref = await Shared().getSharedStorage();
    final url = Uri.parse(Urls.bookingUpdate + reference + "/payment");
    final response = await http.put(url,
        headers: {
          'Content-Type': ContentType.urlEncode,
          'Authorization': 'Bearer $token'
        },
        body: body);
    print("status code:${response.statusCode}");
    if (response.statusCode == 403) {
      await RefreshToken().getData();
      final userToken = pref.getString("user_token");
      final response = await http.put(url,
          headers: {
            'Content-Type': ContentType.urlEncode,
            'Authorization': 'Bearer $userToken'
          },
          body: body);
      return json.decode(response.body);
    }
    print("Update:${json.decode(response.body)}");
    return json.decode(response.body);
  }

  Future clearCart(String token) async {
    final pref = await Shared().getSharedStorage();
    if (pref.containsKey("user_token")) {
      if (pref.get("user_token") == null) {
        await RefreshToken().getData();
      }
    } else {
      await RefreshToken().getData();
    }
    final response = await Http()
        .delete("", Urls.getCart, pref.get('user_token'), ContentType.json);
    switch (response.statusCode) {
      case 200:
        await clearDB();
        return jsonDecode(response.body);
      case 403:
        await RefreshToken().getData();
        final response = await Http()
            .delete("", Urls.getCart, pref.get('user_token'), ContentType.json);
        await clearDB();
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
  }

  Future paymentDialog(BuildContext dcontext) async {
    showDialog(
      barrierDismissible: false,
      context: dcontext,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: CanineText(
                    text: "Payment in Process",
                    maxLines: 2,
                    fontSize: 12.0,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Progress()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  successDialog(BuildContext dcontext, String id) {
    showDialog(
      barrierDismissible: false,
      context: dcontext,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          child: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(dcontext);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => ProfileBloc(),
                                child: ProfilePage(
                                  tabIndexSwitch: true,
                                  toHome: true,
                                ),
                              ),
                            ));
                      }),
                ),
                Container(
                    child: Icon(
                  Icons.done_all,
                  color: Colors.green,
                  size: 50.0,
                )),
                Container(
                  alignment: Alignment.center,
                  child: CanineText(
                    text: "This event has been \nsuccessfully booked",
                    maxLines: 2,
                    fontSize: 20.0,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: CanineText(
                    text: "Your booking id -$id",
                    maxLines: 2,
                    fontSize: 12.0,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: CanineText(
                    text: "You will receive a confirmation email shortly",
                    maxLines: 2,
                    fontSize: 12.0,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  errorDialog(BuildContext dcontext) {
    showDialog(
      barrierDismissible: false,
      context: dcontext,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        isPaying = false;
                        Navigator.pop(dcontext);
                      }),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50.0,
                    )),
                Container(
                  alignment: Alignment.center,
                  child: CanineText(
                    text: "Payment failed \n Try again",
                    maxLines: 2,
                    fontSize: 20.0,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBarPayment(BuildContext context) {
    ConnectivityCheck().getConnectionState().then((value) {
      if (value) {
        CanineSnackBar.show(context, "Something went wrong while initiating payment.Please try with valid card details!");
      }
    });
  }
}
