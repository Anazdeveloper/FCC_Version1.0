import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowEventBLOC extends Bloc<ShowEventPageEvents, ShowEventPageBlocState> {
  ShowEventBLOC() : super(EventUiLoaded());

  @override
  Stream<ShowEventPageBlocState> mapEventToState(
      ShowEventPageEvents event) async* {
    if (event is EventUiLoaded) {
      yield ShowEventInputProcessing();
    }
    if (event is ShowEventData) {
      yield ShowEventDataState();
    }
    if (event is ShowEventDetails) {
      yield ShowEventInputProcessing();
      try {
        final responseBody = await EventsRepo(event.slug).getData();
        if (responseBody.status == true) {
          //print(responseBody.data);
          yield EventLoadingSuccessful(responseBody);
        } else {
          yield ShowEventErrorState(responseBody.message);
        }
      } on SocketException {
       // yield ShowEventErrorState("Something went wrong try again!");
      } on HttpException {
      //  yield ShowEventErrorState("Something went wrong try again!");
      } on Exception {
        yield ShowEventErrorState("Something went wrong try again!");
      } catch (e) {
        print("ShowEvenError:$e");
      }
    }
    if (event is RemoveExistingCart) {
      try {
        final responseBody = await EventsRepo("").clearCart();
        if (responseBody['status'] == true) {
          if (responseBody['data']['cart_cleared'] != null) {
            if (responseBody['data']['cart_cleared'] == true) {
              await EventsRepo("").clearDB();
              await clearSelection(event.details);
              yield RemoveExistingCartState(event.details);
            }
          }
        } else {
          yield ShowEventErrorState("Error while processing.Please retry!");
        }
      } on SocketException {
       // yield ShowEventErrorState("Something went wrong try again!");
      } on HttpException {
       // yield ShowEventErrorState("Something went wrong try again!");
      } on Exception {
        yield ShowEventErrorState("Something went wrong try again!");
      } catch (e) {
        print("ShowEventError:$e");
        yield ShowEventErrorState("Something went wrong try again!");
      }
    }
    if (event is ShowEventError) {
      yield ShowEventErrorState("");
    }
    if (event is CartCheck) {
      yield ShowEventInputProcessing();
      try {
        final responseBody = await EventsRepo(event.event.data!.slug).getCart();
        if (responseBody['status'] == true) {
          if (responseBody['data']['slots'] != null) {
            print(responseBody['data']['slots']);
            if (responseBody['data']['slots'].length > 0) {
              final eventSlug = await compareEventSlots(
                  responseBody['data']['slots'], event.event);
              print(eventSlug);
              yield CartExistingState(event.event, eventSlug);
            } else {
              yield CartCheckState(event.event);
            }
          }
          if (responseBody['data']['cart_expired'] != null) {
            print(
              "details${responseBody['data']}",
            );
            await EventsRepo("").clearDB();
            yield CartCheckState(event.event);
          }
        } else {
          print(responseBody['data']);
          yield ShowEventErrorState(responseBody['data']);
        }
      } on SocketException {
        //yield ShowEventErrorState("Something went wrong try again!");
      } on HttpException {
       // yield ShowEventErrorState("Something went wrong try again!");
      } on Exception {
        yield ShowEventErrorState("Something went wrong try again!");
      } catch (e) {
        print("ShowEventError:$e");
        yield ShowEventErrorState("Something went wrong try again!");
      }
    }
  }

  Future clearSelection(EventDetails event) async {
    event.data!.booths!.forEach((element) {
      element.selected = null;
    });
  }

  Future compareEventSlots(responseBody, EventDetails event) async {
    String? eventSlug;
    for (Map<String, dynamic> index in responseBody) {
      index.forEach((key, value) {
        if (key == "slot_number") {
          print(value);

          event.data!.booths!.forEach((element) {
            if (value == element.number) {
              element.selected = true;
            }
          });
        }
        if (key == "event") {
          eventSlug = value;
        }
      });
    }
    return await Future.value(eventSlug);
  }
}

class ShowEventPageBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventUiLoaded extends ShowEventPageBlocState {}

class ShowEventDataState extends ShowEventPageBlocState {}

class ShowEventInputProcessing extends ShowEventPageBlocState {}

class CartCheckState extends ShowEventPageBlocState {
  final eventDetails;

  CartCheckState(this.eventDetails);
}

class RemoveExistingCartState extends ShowEventPageBlocState {
  final EventDetails eventDetails;

  RemoveExistingCartState(this.eventDetails);
}

class CartExistingState extends ShowEventPageBlocState {
  final EventDetails event;
  final String eventSlug;

  CartExistingState(this.event, this.eventSlug);

  @override
  List<Object?> get props => [event, eventSlug];
}

class EventLoadingSuccessful extends ShowEventPageBlocState {
  final EventDetails evenData;

  EventLoadingSuccessful(this.evenData);
}

class ShowEventErrorState extends ShowEventPageBlocState {
  final String? message;

  ShowEventErrorState(this.message);
}
class ShowNetworkErrorState extends ShowEventPageBlocState {
  final String? message;

  ShowNetworkErrorState(this.message);
}

class ShowEventPageEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShowEventDetails extends ShowEventPageEvents {
  final slug;

  ShowEventDetails(this.slug);

  @override
  List<Object?> get props => [slug];
}

class ShowEventData extends ShowEventPageEvents {}

class ShowEventError extends ShowEventPageEvents {

}
class ShowNetworkError extends ShowEventPageEvents {

}
class RemoveExistingCart extends ShowEventPageEvents {
  final EventDetails details;

  RemoveExistingCart(this.details);
}

class CartCheck extends ShowEventPageEvents {
  final EventDetails event;

  CartCheck(this.event);

  @override
  List<Object?> get props => [event];
}
