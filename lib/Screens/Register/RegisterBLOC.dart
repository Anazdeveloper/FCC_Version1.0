import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Repo/RegisterRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBLOC extends Bloc<RegisterEvents, RegisterBlocState> {
  RegisterBLOC() : super(InputIsNotLoaded());

  @override
  Stream<RegisterBlocState> mapEventToState(RegisterEvents event) async* {
    if (event is RegisterEvent) {
      yield InputIsProcessing();
      try {
        final response = await RegisterRepo(event.data).getData();
        if (response['status'] == true) {
          print("Register:$response");
          yield InputIsRegistered();
        } else {
          if (response['data'] != null) {
            if (response['user_exist']!= null&&response['user_exist'])
              {
                yield EmailErrorState("Email already exists");
              } else{
              yield InlineErrorState("", response['data'], true);
            }
            print("Register:$response");
          }
          print("Register:$response");
          /*if (response['data']['name'] != null) {
            yield InlineErrorState(response['data']['name'][0],"name",true);
            print("Register:$response");
          }
          else if(response['data']['username'] != null) {
            yield EmailErrorState("Email already exists");
            print("Register:$response");
          }
          if (response['data']['password'] != null) {
            yield InlineErrorState(response['data']['password'][0],"password",true);
            print("Register:$response");
          }*/
        }
      } on SocketException {
        yield ErrorState("No network try again!");
      } on HttpException {
        yield ErrorState("No network try again!");
      } on Exception {
        yield ErrorState("Something went wrong try again!");
      } catch (e) {
        yield ErrorState("Something went wrong try again!");
        print("Register:$e");
      }
    }
    if (event is LoginEvent) {
      yield UserVerified();
    }
    if (event is VerifyEvent) {
      yield OTPInputIsProcessing();
      try {
        final response =
            await RegisterRepo("").verifyUser(event.otp, event.email);
        if (response['status'] == true) {
          yield UserVerified();
        } else {
          if (response['data']['otp'][0] != null) {
            yield OTPErrorState(response['data']['otp'][0]);
          }
          yield OTPErrorState("Verification failed");
        }
      } on SocketException {
        yield ErrorState("No network try again!");
      } on HttpException {
        yield ErrorState("No network try again!");
      } on Exception {
        yield ErrorState("Something went wrong try again!");
      } catch (e) {
        yield ErrorState("Something went wrong try again!");
      }
    }
  }
}

class RegisterBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends RegisterEvents {
  final Map<String, String> data;

  RegisterEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class VerifyEvent extends RegisterEvents {
  final String otp, email, password;

  VerifyEvent(this.otp, this.email, this.password);

  @override
  List<Object?> get props => [otp, email, password];
}

class LoginEvent extends RegisterEvents {}

class InputIsNotLoaded extends RegisterBlocState {}

class InputIsProcessing extends RegisterBlocState {}

class OTPInputIsProcessing extends RegisterBlocState {}

class InputIsRegistered extends RegisterBlocState {}

class UserVerified extends RegisterBlocState {}

class ErrorState extends RegisterBlocState {
  final message;

  ErrorState(this.message);
}

class EmailErrorState extends RegisterBlocState {
  final message;

  EmailErrorState(this.message);
}

class InlineErrorState extends RegisterBlocState {
  final bool status;
  final String message;
  final field;

  InlineErrorState(this.message, this.field, this.status);
}

class OTPErrorState extends RegisterBlocState {
  final message;

  OTPErrorState(this.message);
}
