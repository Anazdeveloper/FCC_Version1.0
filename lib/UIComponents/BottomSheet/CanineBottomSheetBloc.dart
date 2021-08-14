import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Modal/StaticDataModal.dart';
import 'package:first_class_canine_demo/Repo/StaticDataRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanineBottomSheetBloc extends Bloc<BottomSheetEvent, BottomSheetState> {
  CanineBottomSheetBloc() : super(SheetInputNotLoadedYet());

  @override
  Stream<BottomSheetState> mapEventToState(BottomSheetEvent event) async* {
    if (event is SheetUiLoadedEvent) {
      yield SheetInputNotLoadedYet();
      final StaticDataModal response = await StaticDataRepo().getData();
      if (response.status == true) {
        yield StaticDataLoaded(
            response.data!.aboutUs, response.data!.contactUs);
      } else {
        yield SheetInputErrorState(response.message);
      }
    }
  }
}

class BottomSheetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SheetInputNotLoadedYet extends BottomSheetState {}

class StaticDataLoaded extends BottomSheetState {
  final TUs? aboutData;
  final TUs? contactUsData;

  StaticDataLoaded(this.aboutData, this.contactUsData);
}

class SheetInputErrorState extends BottomSheetState {
  final String? message;

  SheetInputErrorState(this.message);
}

class BottomSheetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SheetUiLoadedEvent extends BottomSheetEvent {}
