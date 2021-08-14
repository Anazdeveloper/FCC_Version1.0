import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Repo/ForgotRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPageBLOC
    extends Bloc<ForgetPasswordEvents, ForgetPasswordBlocState> {
  ForgetPageBLOC() : super(UiState());

  @override
  Stream<ForgetPasswordBlocState> mapEventToState(
      ForgetPasswordEvents event) async* {
    if (event is InputEvent) {
      yield ForgetPasswordInputIsProcessing();
      try {
        final otpResponse = await ForgotRepo().getOtp(event.inputEmail);
        if (otpResponse['status'] == true) {
          yield PasswordChangeOtp(otpResponse['data']);
        } else {
          if (otpResponse['data']['email'] != null) {
            yield ForgetPasswordInlineErrorState(
                otpResponse['data']['email'][0],otpResponse['data'], true);
          }else if (otpResponse['data']['non_field_error'] != null){

            yield ForgetPasswordErrorState(otpResponse['data']['non_field_error'][0]);
          }
        }
      } on SocketException {
        yield ForgetPasswordErrorState("No network try again!");
      } on HttpException {
        yield ForgetPasswordErrorState("No network try again!");
      } on Exception {
        yield ForgetPasswordErrorState("Something went wrong try again!");
      } catch (e) {
        yield ForgetPasswordErrorState("Something went wrong try again!");
        print("ForgetError:$e");
      }
    }
    if (event is ResetEvent) {
      print("OTP:${event.otp}");
      print("Email:${event.inputEmail}");
      yield ForgetPasswordInputEventIsProcessing();
      try {
        final resetResponse = await ForgotRepo().verifyOtp(
            event.inputEmail!, event.otp!, event.npassword!, event.cpassword!);
        if (resetResponse['status'] == true) {
          yield ResetSuccessful();
        } else {
          if (resetResponse['data'] != null) {
            yield ForgetPasswordInlineErrorState(
                "", resetResponse['data'],true);
            print(resetResponse);
          }
          /*if (resetResponse['data']['otp'] != null) {
            yield ForgetPasswordInlineErrorState(resetResponse['data']['otp'][0],"otp",true);
          } else if (resetResponse['data']['email'] != null) {
            yield ForgetPasswordInlineErrorState(resetResponse['data']['email'][0],"email",true);
          } else if (resetResponse['data']['password'] != null) {
            yield ForgetPasswordInlineErrorState(resetResponse['data']['password'][0],"password",true);
          }
          else if (resetResponse['data']['confirm_password']!= null) {
            yield ForgetPasswordInlineErrorState(resetResponse['data']['confirm_password'][0],"confirm",true);
          }*/
        }
      } on SocketException {
        yield ForgetPasswordErrorState("No network try again!");
      } on HttpException {
        yield ForgetPasswordErrorState("No network try again!");
      } on Exception {
        yield ForgetPasswordErrorState("Something went wrong try again!");
      } catch (e) {
        yield ForgetPasswordErrorState("Something went wrong try again!");
        print("ForgetError:$e");
      }
    }
  }
}

class ForgetPasswordEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiLoaded extends ForgetPasswordEvents {}

class InputEvent extends ForgetPasswordEvents {
  final String? inputEmail;

  InputEvent({this.inputEmail});

  @override
  List<Object?> get props => [inputEmail];
}

class ResetEvent extends ForgetPasswordEvents {
  final String? inputEmail;
  final String? otp;
  final String? npassword;
  final String? cpassword;

  ResetEvent({this.inputEmail, this.otp, this.npassword, this.cpassword});

  @override
  List<Object?> get props => [inputEmail, otp, npassword, cpassword];
}

class ForgetPasswordBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiState extends ForgetPasswordBlocState {}

class InputLoadedState extends ForgetPasswordBlocState {}

class ForgetPasswordInputIsProcessing extends ForgetPasswordBlocState {}

class ForgetPasswordInputEventIsProcessing extends ForgetPasswordBlocState {}

class PasswordChangeSuccessful extends ForgetPasswordBlocState {}

class ResetSuccessful extends ForgetPasswordBlocState {}

class PasswordChangeOtp extends ForgetPasswordBlocState {
  final String message;

  PasswordChangeOtp(this.message);
}

class ForgetPasswordErrorState extends ForgetPasswordBlocState {
  final String message;

  ForgetPasswordErrorState(this.message);
}

class ForgetPasswordInlineErrorState extends ForgetPasswordBlocState {
  final message;
  final field;
  final bool status;

  ForgetPasswordInlineErrorState(this.message, this.field, this.status);
}
