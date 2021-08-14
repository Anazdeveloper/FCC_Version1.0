import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Repo/ContactUsRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsBloc() : super(InputIsNotLoaded());

  @override
  Stream<ContactUsState> mapEventToState(ContactUsEvent event) async* {
    if (event is ContactInputLoaded) {
      yield InputIsProcessing();
      try {
        final response = await ContactUsRepo(event.inputData).postData();
        print('Response Status : ${response['status']}');
        if (response['status'] == true) {
          yield SubmitSuccessful(response['message']);
        } else {
          if (response['data'] != null) {
            yield ErrorState(response['data']['non_field_erro']);
          }
        }
      } on SocketException {
        yield CommonError('Something went wrong.Please try again!');
      } on HttpException {
        yield CommonError('Something went wrong.Please try again!');
      } catch (e) {
        yield CommonError('Something went wrong.Please try again!');
      }
    }
  }
}

class ContactUsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class InputIsNotLoaded extends ContactUsState {}

class InputIsProcessing extends ContactUsState {}

class SubmitSuccessful extends ContactUsState {
  final message;

  SubmitSuccessful(this.message);
}

class ErrorState extends ContactUsState {
  final message;

  ErrorState(this.message);
}



class CommonError extends ContactUsState {
  final message;

  CommonError(this.message);
}


class ContactUsEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ContactInputLoaded extends ContactUsEvent {
  final Map<String, String> inputData;

  ContactInputLoaded(this.inputData);

  @override
  List<Object?> get props => [inputData];
}
