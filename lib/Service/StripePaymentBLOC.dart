import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Repo/StripeRepo.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentBLOC extends Bloc<StripeEvents, StripeStates> {
  StripePaymentBLOC() : super(StripeUiLoadedState());

  @override
  Stream<StripeStates> mapEventToState(StripeEvents event) async* {
    if (event is PaymentInitiated) {
      final pref = await Shared().getSharedStorage();
      final pubResponse = await StripeRepo()
          .getPublishableKey(pref.get("user_token").toString());
      print(pubResponse);
      if (pubResponse['status'] == true) {
        if (pubResponse['data']['stripe'] != null) {
          Stripe.publishableKey = pubResponse['data']['stripe']['PUB_KEY'];
        }
      }
      final clientSecret = await StripeRepo().fetchPaymentIntentClientSecret(
          pref.get("user_token").toString(),
          event.eventDetails,
          event.event,
          event.booths,
          event.total);
      final billingDetails = BillingDetails();
      if (clientSecret['status'] == true) {
        if (clientSecret['data']['payment'] != null) {
          if (clientSecret['data']['payment']['secret'] != null) {
            final paymentIntent = await Stripe.instance.confirmPaymentMethod(
              clientSecret['data']['payment']['secret'],
              PaymentMethodParams.card(
                billingDetails: billingDetails,
                setupFutureUsage: event.save_card == true
                    ? PaymentIntentsFutureUsage.OffSession
                    : null,
              ),
            );
            await StripeRepo()
                .clearSelection(event.eventDetails)
                .then((value) {});
            final response = await StripeRepo().bookingStatusUpdate(
                clientSecret['data']['reference'],
                pref.get("user_token").toString(),
                {"status": "paid"});
            if (response['status'] == true) {
              yield PaymentInProcessState();
            }
            /*  ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(
                      'Success!: The payment was confirmed successfully!')))
                  .closed
                  .then((_) {
                StripeRepo().clearSelection(widget.eventDetails).then((value) async{
                  await StripeRepo().bookingStatusUpdate(clientSecret['data']['reference'],pref.get("user_token").toString(),{"status":"paid"});
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => HomeBloc(),
                          child: HomePage(),
                        ),
                      ));
                });
              });*/
          }
        }
      } else {
        yield PaymentErrorState();
      }
    }
    yield PaymentInitiatedState();
  }
}

class StripeStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class StripeUiLoadedState extends StripeStates {}

class PaymentInitiatedState extends StripeStates {}

class PaymentInProcessState extends StripeStates {}

class PaymentErrorState extends StripeStates {}

class StripeEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitiated extends StripeEvents {
  final CardFieldInputDetails card;
  final bool save_card;
  final String event;
  final double total;
  final List<Map<String, dynamic>> booths;
  final EventDetails eventDetails;
  PaymentInitiated(this.card, this.save_card, this.eventDetails, this.total,
      this.booths, this.event);
}
