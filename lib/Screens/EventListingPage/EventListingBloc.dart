import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Modal/EventListModal.dart';
import 'package:first_class_canine_demo/Repo/EventListingRepo.dart';
import 'package:first_class_canine_demo/Repo/HomeRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventListingBloc extends Bloc<EventListEvent, EventListState> {
  EventListingBloc() : super(EventListInputNotLoadedYet());

  @override
  Stream<EventListState> mapEventToState(EventListEvent event) async* {
    if (event is EventListingUiLoadedEvent) {
      yield EventListInputNotLoadedYet();
      final EventList pastResponse = await EventListingRepo().getData();
      final EventList upcomingResponse = await HomeRepo().getData();
      yield DataLoaded(pastResponse.data, upcomingResponse.data);
    }
  }
}

//Event
class EventListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEvents extends EventListEvent {}

class ViewAllEvents extends EventListEvent {}

class BookNow extends EventListEvent {}

class EventListDetails extends EventListEvent {}

class EventListingUiLoadedEvent extends EventListEvent {}

//State
class EventListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventListUiLoaded extends EventListState {}

class EventListInputNotLoadedYet extends EventListState {}

class EventListInputProcessing extends EventListState {}

class EventListInputLoadingSuccessful extends EventListState {}

class DataLoaded extends EventListState {
  final List<EventData> pastData;
  final List<EventData> upcomingData;

  DataLoaded(this.pastData, this.upcomingData);
}

class EventListInputErrorState extends EventListState {
  final String? message;

  EventListInputErrorState(this.message);
}
