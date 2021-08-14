import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Modal/MyEventCancelModal.dart';
import 'package:first_class_canine_demo/Modal/MyEventErrorModel.dart';
import 'package:first_class_canine_demo/Modal/MyEventModal.dart';
import 'package:first_class_canine_demo/Repo/UserEventRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyEventDetailsBLOC
    extends Bloc<MyEventDetailsEvents, MyEventDetailsState> {
  MyEventDetailsBLOC() : super(MyEventUiLoaded());

  @override
  Stream<MyEventDetailsState> mapEventToState(
      MyEventDetailsEvents event) async* {
    try {
      if (event is MyEventFetch) {
        final myEventResponse = await UserEventRepo().getEvent(event.reference);
        if (myEventResponse.status == true) {
          yield MyEventLoadedSuccessful(myEventResponse);
        } else {
          yield MyEventErrorState(myEventResponse);
        }
      }
      if (event is MyEventCancel) {
        yield MyEventCancelling();
        final myEventResponse =
            await UserEventRepo().cancelEvent(event.reference);
        if (myEventResponse.status == true) {
          yield MyEventCancelSuccessful(myEventResponse);
        } else {
          yield MyEventErrorState(myEventResponse);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

class MyEventDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyEventLoadedSuccessful extends MyEventDetailsState {
  final MyEventModal eventModal;

  MyEventLoadedSuccessful(this.eventModal);
}

class MyEventCancelling extends MyEventDetailsState {}

class MyEventCancelSuccessful extends MyEventDetailsState {
  final MyEventCancelModal cancelModal;

  MyEventCancelSuccessful(this.cancelModal);
}

class MyEventErrorState extends MyEventDetailsState {
  final MyEventErrorModal errorModal;

  MyEventErrorState(this.errorModal);
}

class MyEventUiLoaded extends MyEventDetailsState {}

class MyEventDetailsEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyEventFetch extends MyEventDetailsEvents {
  final String reference;

  MyEventFetch(this.reference);

  @override
  List<Object?> get props => [reference];
}

class MyEventCancel extends MyEventDetailsEvents {
  final String reference;

  MyEventCancel(this.reference);

  @override
  List<Object?> get props => [reference];
}
