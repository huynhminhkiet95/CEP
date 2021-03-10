import 'dart:async';
import 'dart:convert';

import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/blocs/DriverProfile/driver_profile_event.dart';
import 'package:CEPmobile/blocs/DriverProfile/driver_profile_state.dart';
import 'package:CEPmobile/models/users/userprofile.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import '../../GlobalTranslations.dart';
import '../../globalDriverProfile.dart';

class DriverProfileBloc
    extends BlocEventStateBase<DriverProfileEvent, DriverProfileState> {
  final CommonService _commonService;
  final SharePreferenceService sharePreferenceService;
  DriverProfileBloc(this._commonService, this.sharePreferenceService);

  @override
  DriverProfileState get initialState => DriverProfileInitial(
      driverName: globalDriverProfile.getDriverName,
      phoneNumber: globalDriverProfile.getPhoneNumber,
      icNumber: globalDriverProfile.geticNumber,
      licenseNumber: globalDriverProfile.getlicenseNumber,
      fleet: globalDriverProfile.getfleet);

  static final BehaviorSubject<Userprofile> _userProfileController =
      BehaviorSubject<Userprofile>();
  Stream<Userprofile> get dataUserProfile => _userProfileController;

  @override
  Stream<DriverProfileState> eventHandler(
      DriverProfileEvent event, DriverProfileState currentState) async* {
    if (event is DriverProfileDefault) {
      yield DriverProfileInitial(
          driverName: globalDriverProfile.getDriverName,
          phoneNumber: globalDriverProfile.getPhoneNumber,
          icNumber: globalDriverProfile.geticNumber,
          licenseNumber: globalDriverProfile.getlicenseNumber,
          fleet: globalDriverProfile.getfleet,
          avatar: globalDriverProfile.getavatar);
    }
    if (event is DriverProfileStart) {
      yield DriverProfileLoading(true);
      final response = await this._commonService.getUserProfile(event.id);
      if (response != null && response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var dataJson = json.decode(response.body);
          if (dataJson.length > 0) {
            var childJson =
                dataJson["payload"].cast<Map<String, dynamic>>() as List;
            var datas = new List<Userprofile>();
            if (childJson.length > 0) {
              datas = childJson
                  .map<Userprofile>(
                      (jsonItem) => Userprofile.fromJson(jsonItem))
                  .toList();
              if (!_userProfileController.isClosed) {
                _userProfileController.sink.add(datas[0]);
              }
            }
          }
        }
      }
      yield DriverProfileLoading(false);
    }

    if (event is DriverProfileUpdate) {
      yield DriverProfileLoading(true);
      await new Future.delayed(new Duration(milliseconds: 200), () {});
      sharePreferenceService.saveDriverProfile(
          event.driverName,
          event.phoneNumber,
          event.icNumber,
          event.licenseNumber,
          event.fleet,
          event.avatar);
      // var fleet = event.fleet;
      // var strJson = '{"SessionId": "$sessionId", "FleetId": "$fleet", "Token":"$tokenfcm"}';
      // socket.emit(SocketIOEvent.update_fleetId, [strJson]);

      yield DriverProfileInitial(
          driverName: event.driverName,
          phoneNumber: event.phoneNumber,
          icNumber: event.icNumber,
          licenseNumber: event.licenseNumber,
          fleet: event.fleet,
          avatar: event.avatar);
      Fluttertoast.showToast(
          msg: allTranslations.text("Updatesuccess"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void dispose() {
    _userProfileController?.close();
  }
}
