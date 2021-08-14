import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Repo/BookingRepo.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Storage/Database/Booking.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingBLOC extends Bloc<BookingPageEvents, BookingPageBlocStates> {
  BookingBLOC() : super(BookingPageInitialUiLoaded());

  @override
  Stream<BookingPageBlocStates> mapEventToState(
      BookingPageEvents event) async* {
    if (event is BookingPageLoaded) {
      yield BookingPageInitialUiLoaded();
    }
    if (event is LoadingEvent) {
      yield BookingPageInitialUiLoaded();
    }
    if (event is BookingPageBoothSelection) {
      yield ShowDialog();
      try {
        final cartResponse = await EventsRepo("").getCart();
        if (cartResponse['status'] == true) {
          if (cartResponse['data']['cart_expired'] != null) {
            yield BookingPageCartClearState();
          }
        }
        final response = await BookingRepo(inputData: event.booking).getData();
        if (response['status'] == true) {
          await BookingRepo().insertBooking(event.booking);
          yield BookingUiReload(event.index); //An error
        } else {
          if (response['data']['slot_number'] != null) {
            yield BookingPageErrorState(response['data']['slot_number'][0]);
          } else if (response['data']['event'] != null) {
            yield BookingPageErrorState(response['data']['event'][0]);
          } else if (response['data']['non_field_error'] != null) {
            yield BookingPageErrorState(response['data']['non_field_error'][0]);
          }
        }
      } on SocketException {
        yield BookingPageErrorState("Something went wrong try again!");
      } on HttpException {
        yield BookingPageErrorState("Something went wrong try again!");
      } catch (e) {
        print("BookingError:$e");
        yield BookingPageErrorState("Something went wrong try again!");
      }
    }
    if (event is CheckCartEvent) {
      yield BookingProcessing();
      try {
        final cartResponse = await EventsRepo("").getCart();
        if (cartResponse['status'] == true) {
          if (cartResponse['data']['slots'] != null) {
            if (cartResponse['data']['slots'].length > 0) {
              yield BookingCartCheckState();
            }
          } else {
            yield BookingPageCartErrorState("Cart expired");
          }
        } else {
          yield BookingPageCartErrorState("Cart expired");
        }
      } on SocketException {
        yield BookingPageErrorState("Something went wrong try again!");
      } on HttpException {
        yield BookingPageErrorState("Something went wrong try again!");
      } catch (e) {
        print("BookingError:$e");
        yield BookingPageErrorState("Something went wrong try again!");
      }
    }
    if (event is BookingPageBoothDeletion) {
      yield BookingDeleteDialog();
      try {
        final response =
            await BookingRepo(inputData: event.booking).deleteData();
        if (response['status'] == true) {
          await BookingRepo().deleteBooking(event.booking);
          yield BookingDeleteUiReload(event.index);
        } else {
          if (response['data']['cart_expired'] != null) {
            print(response['data']['cart_expired']);
            if (response['data']['cart_expired'] == true) {
              await BookingRepo().clearDB();
              yield BookingPageExpired();
            } else {
              yield BookingPageErrorState("Failed to delete");
            }
          } else if (response['data']['event'] != null) {
            yield BookingPageErrorState(response['data']['event'][0]);
          } else if (response['data']['non_field_error'] != null) {
            yield BookingPageErrorState(response['data']['non_field_error'][0]);
          }
        }
      } on SocketException {
        yield BookingPageErrorState("Something went wrong try again!");
      } on HttpException {
        yield BookingPageErrorState("Something went wrong try again!");
      } catch (e) {
        print("BookingError:$e");
        yield BookingPageErrorState("Something went wrong try again!");
      }
    }
    if (event is BookingPageAddPet) {
      await BookingRepo().addPet(event.addPet);
      yield BookingPetsUiReload();
    }
    if (event is BookingPageRemovePet) {
      await BookingRepo().removePet(event.removePet);
      yield BookingPetsUiReload();
    }
    if (event is BookingConfirm) {
      //final jsonData=await BookingRepo().insertBooking(booking);
      //await BookingRepo().bookingConfirm(json);
      yield BookingPetsUiReload();
    }
  }
}

class BookingPageEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingPageLoaded extends BookingPageEvents {}

class LoadingEvent extends BookingPageEvents {}

class CheckCartEvent extends BookingPageEvents {}

class BookingPageBoothSelection extends BookingPageEvents {
  final Booking booking;
  final int index;

  BookingPageBoothSelection(this.booking, this.index);

  @override
  List<Object?> get props => [booking, index];
}

class BookingPageBoothDeletion extends BookingPageEvents {
  final Booking booking;
  final int index;

  BookingPageBoothDeletion(this.booking, this.index);
}

class BookingPageAddPet extends BookingPageEvents {
  final Booking addPet;

  BookingPageAddPet(this.addPet);

  @override
  List<Object?> get props => [addPet];
}

class getBookingCart extends BookingPageEvents {}

class BookingPageRemovePet extends BookingPageEvents {
  final Booking removePet;

  BookingPageRemovePet(this.removePet);

  @override
  List<Object?> get props => [removePet];
}

class BookingConfirm extends BookingPageEvents {}

class BookingPageBlocStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingPageInitialUiLoaded extends BookingPageBlocStates {}

class BookingBoothSelected extends BookingPageBlocStates {}

class BookingBoothDeletion extends BookingPageBlocStates {}

class BookingProcessing extends BookingPageBlocStates {}

class BookingCartCheckState extends BookingPageBlocStates {}

class BookingUiReload extends BookingPageBlocStates {
  final int index;

  BookingUiReload(this.index);
}

class BookingDeleteUiReload extends BookingPageBlocStates {
  final int index;

  BookingDeleteUiReload(this.index);
}

class BookingDeleteDialog extends BookingPageBlocStates {}

class BookingPetsUiReload extends BookingPageBlocStates {}

class ShowDialog extends BookingPageBlocStates {}

class BookingRemovePet extends BookingPageBlocStates {}

class BookingConfirmState extends BookingPageBlocStates {}

class BookingPageExpired extends BookingPageBlocStates {}

class BookingPageErrorState extends BookingPageBlocStates {
  final String message;

  BookingPageErrorState(this.message);
}

class BookingPageCartErrorState extends BookingPageBlocStates {
  final String message;

  BookingPageCartErrorState(this.message);
}

class BookingPageCartClearState extends BookingPageBlocStates {}
