import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Modal/EventListModal.dart';
import 'package:first_class_canine_demo/Repo/HomeRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInputNotLoadedYet());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeUiLoadedEvent) {
      yield HomeInputNotLoadedYet();
      final EventList response = await HomeRepo().getData();
      yield HomeDataLoaded(response.data);
    }
  }
}

//Event
class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEvents extends HomeEvent {}

class ViewAllEvents extends HomeEvent {}

class BookNow extends HomeEvent {}

class HomeDetails extends HomeEvent {}

class HomeUiLoadedEvent extends HomeEvent {}

//State
class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeUiLoaded extends HomeState {}

class HomeInputNotLoadedYet extends HomeState {}

class HomeInputProcessing extends HomeState {}

class HomeInputLoadingSuccessful extends HomeState {}

class HomeDataLoaded extends HomeState {
  final List<EventData> data;

  HomeDataLoaded(this.data);
}

class HomeInputErrorState extends HomeState {
  final String? message;

  HomeInputErrorState(this.message);
}
