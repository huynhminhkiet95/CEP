import 'dart:convert';
import 'dart:io';

import 'package:CEPmobile/blocs/triprecord/triprecord_event.dart';
import 'package:CEPmobile/blocs/triprecord/triprecord_state.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/comon/lastestMile.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/services/sharePreference.dart';

import '../../GlobalTranslations.dart';

class TripRecordBloc
    extends BlocEventStateBase<TripRecordEvent, TripRecordState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;
  String equipmentNo = "";
  int lastestMileage = 0;

  TripRecordBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: TripRecordState.init()) {
    //equipmentNo = globalDriverProfile.getEquipmentNo;

    //emitEvent(GetLastestMileage(globalDriverProfile.getfleet));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Stream<TripRecordState> eventHandler(
      TripRecordEvent event, TripRecordState currentState) async* {
    // if (event is SaveTripRecord) {
    //    yield TripRecordState.loading(true);
    //    yield TripRecordState.loading(false);
    // }
    // if(event is SaveDayTripRecord)
    // {

    // }
    if (event is SaveTripRecord) {
      yield TripRecordState.loading(true);

      var response = await commonService.saveTriprecord(
          event.tripRecord, globalUser.getSubsidiaryId);

      if (response.statusCode == 200) {
        DBProvider.db.insertTriprecord(
            event.tripRecord.routeMemo, event.tripRecord.tripMemo);
        var dataJson = json.decode(response.body);
        if (dataJson["success"] == true) {
          Fluttertoast.showToast(
              msg: allTranslations.text("Savesuccess"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: allTranslations.text("Savefail"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: allTranslations.text("Savefail"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      yield TripRecordState.loading(false);
    }

    if (event is SaveDayTripRecord) {
      yield TripRecordState.loading(true);
      var response = await commonService.saveDayTriprecord(
          event.daytripRecord, globalUser.getSubsidiaryId);

      if (response != null && response.statusCode == 200) {
        DBProvider.db.insertTriprecord(
            event.daytripRecord.routeMemo, event.daytripRecord.tripMemo);
        var dataJson = json.decode(response.body);

        if (dataJson["success"] == true) {
          if (dataJson["payload"] > 0) {
            for (var i = 0; i < event.listImage.length; i++) {
              File fileImage = File(event.listImage[i]);
              var response =
                  await commonService.saveImage(fileImage, dataJson["payload"]);
              if (response.reasonPhrase == "OK") {
                Fluttertoast.showToast(
                    msg: "Save Image success",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.blueAccent,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }
          }
          Fluttertoast.showToast(
              msg: allTranslations.text("Savesuccess"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: allTranslations.text("Savefail"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: allTranslations.text("Savefail"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      yield StateSuccess(
        isSuccess: true,
      );
    }

    if (event is GetLastestMileage) {
      yield TripRecordState.loading(true);
      var response = await commonService.getLastestMileage(
          globalDriverProfile.getfleet, globalUser.getSubsidiaryId);

      if (response != null && response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        var lastestMileJson =
            dataJson["payload"].cast<Map<String, dynamic>>() as List;
        if (lastestMileJson.length > 0) {
          var lastestMiles = lastestMileJson
              .map<LastestMile>((json) => LastestMile.fromJson(json))
              .toList();
          if (lastestMiles.length > 0 && lastestMiles[0].lastestMile != null) {
            lastestMileage = lastestMiles[0].lastestMile;
          }
        }
      } else {
        lastestMileage = 0;
      }
      yield TripRecordState.getLastestMileage(lastestMileage, false);
    }
  }
}
