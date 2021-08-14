import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmationBLOC extends Bloc<ConfirmationEvents, ConfirmationStates> {
  ConfirmationBLOC() : super(ConfirmationUiLoaded());

  @override
  Stream<ConfirmationStates> mapEventToState(ConfirmationEvents event) async* {
    yield ConfirmationUiLoaded();
    try {
      if (event is ConfirmEvent) {
        print(event);
        yield ConfirmationProcessing();
        final cartResponse = await EventsRepo("").getCart();
        print(cartResponse);
        if (cartResponse['status'] == true) {
          if (cartResponse['data']['slots'] != null) {
            if (cartResponse['data']['slots'].length > 0) {
              yield ConfirmationState();
            }
          } else {
            yield ConfirmationErrorState();
          }
        } else {
          yield ConfirmationErrorState();
        }
      }
    } catch (e) {}
  }
}

class ConfirmationUiLoaded extends ConfirmationStates {}

class ConfirmationProcessing extends ConfirmationStates {}

class ConfirmationState extends ConfirmationStates {}

class ConfirmationAddressCheckState extends ConfirmationStates {}

class ConfirmationErrorState extends ConfirmationStates {}

class ConfirmationStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConfirmationEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConfirmEvent extends ConfirmationEvents {}

class ConfirmFetchEvent extends ConfirmationEvents {}
