import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Repo/LoginRepo.dart';
import 'package:first_class_canine_demo/Repo/RegisterRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBLOC extends Bloc<LoginEvents, LoginBlocState> {
  LoginBLOC() : super(LoginInputNotLoadedYet());

  @override
  Stream<LoginBlocState> mapEventToState(LoginEvents event) async* {
    if (event is InputLoaded) {
      yield LoginInputIsProcessing();
      try {
        final response = await LoginRepo(event.inputData).getData();
        if (response['status'] == true) {
          final addressResponse = await LoginRepo(event.inputData).getAddress();
          yield LoginSuccessful();
        } else {
          if (response['data'] != null) {
            print(response['data']);
            if (response['data']['non_field_error'] != null)
              {
                //yield LoginErrorState(response['data']['non_field_error'][0]);
                yield LoginSuccessfulVerify();

              }
            else{
              yield LoginInlineErrorState("", response['data'], true);
            }
            //yield LoginErrorState("This email id is not registered with us");
          }
          /* if (response['data']['username'] != null) {
            yield LoginInlineErrorState(response['data']['username'][0],"username",true);
            //yield LoginErrorState("This email id is not registered with us");
          } else if (response['data']['password'] != null) {
            yield LoginInlineErrorState(response['data']['password'][0],"password",true);
            //yield LoginErrorState("Incorrect password");
          } else if (response['data']['non_field_error'] != null) {
            //yield LoginErrorState(response['data']['non_field_error'][0]);
            //yield LoginErrorState("Account not activated");
            yield LoginSuccessfulVerify();
          }*/
        }
      } on SocketException {
        yield LoginErrorState("No network ");
      } on HttpException {
        yield LoginErrorState("No network ");
      } on Exception {
        yield LoginErrorState("Something went wrong try again!");
      } catch (e) {
        print("LoginError:$e");
        yield LoginErrorState("Something went wrong try again!");
      }
    }
    if (event is LoginOTPResend) {
      try {
        final response = await LoginRepo(event.inputData).getData();
        if (response['status'] == false) {
          if (response['data']['non_field_error'] != null) {
            yield LoginErrorState("An OTP is send to your email");
          }
        }
      } catch (e) {}
    }
    if (event is VerifyUserEvent) {
      try {
        yield LoginOTPInputIsProcessing();
        final otpResponse =
            await RegisterRepo("").verifyUser(event.otp, event.email);
        if (otpResponse['status'] == true) {
          dynamic data = {"username": event.email, "password": event.password};
          yield LoginOTPInputIsProcessing();
          final response = await LoginRepo(data).getData();
          if (response['status'] == true) {
            final addressResponse = await LoginRepo(data).getAddress();
            yield LoginOTPSuccessful();
          } else {
            if (response['data']['username'] != null) {
              yield LoginErrorState(response['data']['username'][0]);
              //yield LoginErrorState("This email id is not registered with us");
            } else if (response['data']['password'] != null) {
              yield LoginErrorState(response['data']['password'][0]);
              //yield LoginErrorState("Incorrect password");
            } else if (response['data']['non_field_error'] != null) {
              // yield LoginErrorState("Account not activated");
              yield LoginErrorState(response['data']['non_field_error'][0]);
              yield LoginSuccessfulVerify();
            }
          }
        } else {
          if (otpResponse['data']['otp'][0] != null) {
            yield LoginOTPErrorState(otpResponse['data']['otp'][0]);
          }
          yield LoginOTPErrorState("Verification failed");
        }
      } on SocketException {
        yield LoginErrorState("No network");
      } on HttpException {
        yield LoginErrorState("No network");
      } on Exception {
        yield LoginErrorState("Something went wrong try again!");
      } catch (e) {
        print("LoginError:$e");
        yield LoginErrorState("Something went wrong try again!");
      }
    }
  }
}

class LoginEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiLoaded extends LoginEvents {}

class InputLoaded extends LoginEvents {
  final Map<String, String> inputData;

  InputLoaded(this.inputData);

  @override
  List<Object?> get props => [inputData];
}

class LoginUiLoadedEvent extends LoginEvents {}

class LoginOTPResend extends LoginEvents {
  final Map<String, String> inputData;

  LoginOTPResend(this.inputData);

  @override
  List<Object?> get props => [inputData];
}

class VerifyUserEvent extends LoginEvents {
  final String otp, email, password;

  VerifyUserEvent(this.otp, this.email, this.password);

  @override
  List<Object?> get props => [otp, email, password];
}

class LoginBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiLoadedState extends LoginBlocState {}

class InputLoadedState extends LoginBlocState {}

class LoginUserVerified extends LoginBlocState {}

class LoginInputIsProcessing extends LoginBlocState {}

class LoginOTPInputIsProcessing extends LoginBlocState {}

class LoginSuccessful extends LoginBlocState {}

class LoginOTPSuccessful extends LoginBlocState {}

class LoginSuccessfulVerify extends LoginBlocState {}

class LoginInputNotLoadedYet extends LoginBlocState {}

class LoginErrorState extends LoginBlocState {
  final message;

  LoginErrorState(this.message);
}

class LoginInlineErrorState extends LoginBlocState {
  final message;
  final field;
  final bool status;

  LoginInlineErrorState(this.message, this.field, this.status);
}

class LoginOTPErrorState extends LoginBlocState {
  final message;

  LoginOTPErrorState(this.message);
}
