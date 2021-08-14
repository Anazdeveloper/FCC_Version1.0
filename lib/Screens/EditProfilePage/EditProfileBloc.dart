import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Repo/EditBillingRepo.dart';
import 'package:first_class_canine_demo/Repo/EditProfileRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileUiLoadedState());

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditBillingInputSaved) {
      yield EditBillingInputIsProcessing();
      try {
        final response = await EditBillingRepo(event.inputData).getData();
        print('Response: ${response['status']}');
        if (response['status'] == true) {
          yield EditBillingSaveSuccessful(response['message']);
        } else {
            if(response['data'] != null) {
              yield InlineErrorState(response['message'], response['data'], true);
            }
            print("Error on updation:$response");
          // if (response['data']['street'] != null) {
          //   yield EditBillingErrorState(response['data']['street'][0]);
          // } else if (response['data']['city'] != null) {
          //   yield EditBillingErrorState(response['data']['city'][0]);
          // } else if (response['data']['state'] != null) {
          //   yield EditBillingErrorState(response['data']['state'][0]);
          // } else if (response['data']['zip'] != null) {
          //   yield EditBillingErrorState(response['data']['zip'][0]);
          // }
        }
      } catch (e) {
        yield EditBillingErrorState("Something went wrong.Please try again");
      }
    }

    if (event is EditProfileInputSaved) {
      yield EditProfileInputIsProcessing();
      try {
        final response = await EditProfileRepo(event.inputData).getData();
        print('Response: ${response['status']}');
        if (response['status'] == true) {
          yield EditProfileSaveSuccessful(response['message']);
        } else {
          if (response['data']['name'] != null) {
            yield InlineErrorState(response['message'], response['data'], true);

            //yield EditProfileErrorState(response['data']['name'][0]);
          }
        }
      } catch (e) {
        yield EditProfileErrorState("Something went wrong.Please try again");
      }
    }
  }
}

// Events
class EditProfileEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class EditProfileUiLoaded extends EditProfileEvent {}

class EditProfileInputSaved extends EditProfileEvent {
  final Map<String, String> inputData;

  EditProfileInputSaved(this.inputData);

  @override
  List<Object?> get props => [inputData];
}

class EditBillingInputSaved extends EditProfileEvent {
  final Map<String, String> inputData;

  EditBillingInputSaved(this.inputData);

  @override
  List<Object?> get props => [inputData];
}

//States
class EditProfileState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class EditProfileUiLoadedState extends EditProfileState {}

class EditProfileInputLoadedState extends EditProfileState {}

class EditBillingInputLoadedState extends EditProfileState {}

class EditProfileInputIsProcessing extends EditProfileState {}

class EditBillingInputIsProcessing extends EditProfileState {}

class EditProfileSaveSuccessful extends EditProfileState {
  final message;

  EditProfileSaveSuccessful(this.message);
}

class EditBillingSaveSuccessful extends EditProfileState {
  final message;

  EditBillingSaveSuccessful(this.message);
}

class EditProfileErrorState extends EditProfileState {
  final message;

  EditProfileErrorState(this.message);
}

class EditBillingErrorState extends EditProfileState {
  final message;

  EditBillingErrorState(this.message);
}

class InlineErrorState extends EditProfileState {
  final bool status;
  final String message;
  final data;

  InlineErrorState(this.message, this.data, this.status);
}
