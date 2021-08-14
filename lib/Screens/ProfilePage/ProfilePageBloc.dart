import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Modal/BookingListModal.dart';
import 'package:first_class_canine_demo/Modal/ProfileModal.dart';
import 'package:first_class_canine_demo/Modal/UserAddressModal.dart';
import 'package:first_class_canine_demo/Repo/ProfileRepo.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInputNotLoadedYet());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    final pref = await Shared().getSharedStorage();
    try {
      if (event is ProfileNetworkEvent) {
        yield ProfileNoNetwork();
      }
      if (event is ProfileLogoutEvent) {
        yield ProfileLogout();
      }
      if (event is ProfileUiLoadedEvent) {
        yield ProfileInputNotLoadedYet();
        final Profile profileResponse = await ProfileRepo().getProfileData();
        final BookingListModal bookinglistResponse =
            await ProfileRepo().getBookingList();
        UserAddressModal addressResponse = UserAddressModal();
        if (pref.containsKey("addr_id")) {
          if (pref.getString("addr_id") != null) {
            addressResponse = await ProfileRepo().getAddressData();
            print('AddressResponseData: ${addressResponse.data}');
          }
        }

        yield ProfileDataLoaded(profileResponse.data, addressResponse.data,
            pref.containsKey('addr_id'), bookinglistResponse.data);
      }
    } on SocketException {
      yield ProfileNoNetwork();
    } on HttpException {
      yield ProfileNoNetwork();
    } on Exception {
      yield ProfileNoNetwork();
    } catch (e) {}
  }
}

// Events
class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileUiLoadedEvent extends ProfileEvent {}

class ProfileNetworkEvent extends ProfileEvent {}


class ProfileNoNetworkEvent extends ProfileEvent {}

class ProfileLogoutEvent extends ProfileEvent {}

//States
class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileUiLoaded extends ProfileState {}

class ProfileNoNetwork extends ProfileState {}

class ProfileLogout extends ProfileState {}

class ProfileInputNotLoadedYet extends ProfileState {}

class ProfileDataLoaded extends ProfileState {
  final ProfileData profileData;
  final AddressData? addressData;
  final BookingData? bookingData;
  final bool addressId;

  ProfileDataLoaded(
      this.profileData, this.addressData, this.addressId, this.bookingData);
}
