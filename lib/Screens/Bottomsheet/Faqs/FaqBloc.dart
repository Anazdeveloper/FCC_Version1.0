import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Modal/FaqModal.dart';
import 'package:first_class_canine_demo/Repo/FaqRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  FaqBloc() : super(FaqInputNotLoadedYet());

  @override
  Stream<FaqState> mapEventToState(FaqEvent event) async* {
    if (event is FaqUiLoadedEvent) {
      yield FaqInputNotLoadedYet();
      final FaqModal response = await FaqRepo().getData();
      if (response.status == true) {
        yield FaqDataLoaded(response.data);
      } else {
        yield FaqInputErrorState(response.message);
      }
    }
  }
}

class FaqState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FaqInputNotLoadedYet extends FaqState {}

class FaqDataLoaded extends FaqState {
  final List<FaqData>? faqData;

  FaqDataLoaded(
    this.faqData,
  );
}

class FaqInputErrorState extends FaqState {
  final String? message;

  FaqInputErrorState(this.message);
}

class FaqEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FaqUiLoadedEvent extends FaqEvent {}
