import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Service/Api.dart';

class ChangePasswordBLOC
    extends Bloc<ChangePasswordEvents, ChangePasswordBlocState> {
  ChangePasswordBLOC() : super(UiState());

  @override
  Stream<ChangePasswordBlocState> mapEventToState(
      ChangePasswordEvents event) async* {
    if (event is ChangePasswordInputEvent) {
      yield ChangePasswordInputIsProcessing();
      final pref = await Shared().getSharedStorage();
      if (pref.containsKey('user_token')) {
        //print("user-"+pref.get('user_token').toString());
        try {
          final response = await Http().post(
              event.inputData,
              Urls.changePassword,
              pref.get('user_token'),
              ContentType.urlEncode);
          switch (response.statusCode) {
            case 200:
              final responseBody = jsonDecode(response.body);
              if (responseBody['status'] == true) {
                yield PasswordChangeSuccessful();
              }
              break;
            case 403:
              final responseBody = jsonDecode(response.body);
              if (responseBody['status'] == false) {
                await RefreshToken().getData();
                final responseToken = await Http().post(
                    event.inputData,
                    Urls.changePassword,
                    pref.get('user_token'),
                    ContentType.urlEncode);
                final responseData = jsonDecode(responseToken.body);
                if (responseData['status'] == true) {
                  print(responseData);
                  yield PasswordChangeSuccessful();
                }
              }
              break;
            default:
              final responseBody = jsonDecode(response.body);
              print(responseBody);
              if (responseBody['status'] == false) {
                if (responseBody['data'] != null) {
                  yield ChangePasswordInlineErrorState(
                      "", responseBody['data'], true);
                }

                /* if(responseBody['data']['old_password']!=null)
                  {
                    yield ChangePasswordInlineErrorState(responseBody['data']['old_password'][0],"password",true);
                  }
                else if(responseBody['data']['confirm_password']!=null)
                  {
                    yield ChangePasswordInlineErrorState(responseBody['data']['confirm_password'][0],"confirm",true);
                  }
                  //yield ChangePasswordErrorState("Password Mismatch");
                else if(responseBody['data']['new_password']!=null)
                  {
                    yield ChangePasswordInlineErrorState(responseBody['data']['new_password'][0],"new",true);
                  }*/
                //yield ChangePasswordErrorState("New password cannot be the old password");
              }
              break;
          }
        } catch (e) {
          print(e);
          yield ChangePasswordErrorState("No network");
        }
      }
    }
  }
}

class ChangePasswordEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiLoaded extends ChangePasswordEvents {}

class ChangePasswordInputEvent extends ChangePasswordEvents {
  final Map<String, String> inputData;

  ChangePasswordInputEvent(this.inputData);

  @override
  List<Object?> get props => [inputData];
}

class ChangePasswordBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiState extends ChangePasswordBlocState {}

class InputLoadedState extends ChangePasswordBlocState {}

class ChangePasswordInputIsProcessing extends ChangePasswordBlocState {}

class PasswordChangeSuccessful extends ChangePasswordBlocState {}

class ChangePasswordErrorState extends ChangePasswordBlocState {
  final message;

  ChangePasswordErrorState(this.message);
}

class ChangePasswordInlineErrorState extends ChangePasswordBlocState {
  final message;
  final field;
  final bool status;

  ChangePasswordInlineErrorState(this.message, this.field, this.status);
}

class ChangePasswordValidate extends ChangePasswordBlocState {}
