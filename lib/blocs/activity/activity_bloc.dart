import 'dart:convert';

import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/dtos/common/getaprrovetriprecords.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/models/comon/aprrovetriprecords.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import '../../GlobalTranslations.dart';
import 'activity_event.dart';
import 'activity_state.dart';

class ActivityBloc extends BlocEventStateBase<ActivityEvent, ActivityState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  ActivityBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: ActivityState.init());

  var _getActivitys = BehaviorSubject<List<Aprrovetriprecords>>();
  Stream<List<Aprrovetriprecords>> get getActivitys => _getActivitys;

  @override
  void dispose() {
    _getActivitys?.close();
    super.dispose();
  }

  @override
  Stream<ActivityState> eventHandler(
      ActivityEvent event, ActivityState state) async* {
    if (event is LoadActivityEvent) {
      yield ActivityLoading();
      var tripTodo = new List<Aprrovetriprecords>();
      //yield ActivityState.updateLoading(true);
      Getaprrovetriprecords data = new Getaprrovetriprecords();
      data.dateFrom = event.dateFrom;
      data.dateTo = event.dateTo;
      data.bookingNo = event.bookingNo;
      data.customerNo = event.customerNo;
      data.approvalStatus = event.approvalStatus;
      data.fleetDesc = globalDriverProfile.getfleet;
      data.isUserVerify = event.isUserVerify;
      data.staffId = globalUser.getStaffId;
      var response = await commonService.getaprrovetriprecords(
          data, globalUser.getSubsidiaryId);

      if (response != null && response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        var tripTodoJson =
            dataJson["payload"].cast<Map<String, dynamic>>() as List;
        if (tripTodoJson.length > 0) {
          tripTodo = tripTodoJson
              .map<Aprrovetriprecords>(
                  (json) => Aprrovetriprecords.fromJson(json))
              .toList();
          if (!_getActivitys.isClosed) _getActivitys.sink.add(tripTodo);
        } else {
          if (_getActivitys?.isClosed != true) {
            _getActivitys.sink.add(new List<Aprrovetriprecords>());
          }
        }
      }
      yield ActivityState.updateLoading(false, tripTodo);
    }

    if (event is DeleteTrip) {
      yield ActivityLoading();
      var response = await commonService.deletetriprecord(
          event.id, globalUser.getId, globalUser.getSubsidiaryId);

      if (response != null && response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        if (dataJson["success"] == true) {
          Fluttertoast.showToast(
              msg: allTranslations.text("deletesuccess"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0);
          DateTime firstDayOfMonth =
              new DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
          DateTime lastDayOfMonth =
              new DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
          LoadActivityEvent(
              dateFrom:
                  '${firstDayOfMonth.month}/${firstDayOfMonth.day}/${firstDayOfMonth.year}',
              dateTo:
                  '${lastDayOfMonth.month}/${lastDayOfMonth.day}/${lastDayOfMonth.year}',
              approvalStatus: '',
              bookingNo: '',
              customerNo: '',
              fleetDesc: globalDriverProfile.getfleet,
              isUserVerify: '');
          yield ActivitySuccess(success: true);
        } else {
          Fluttertoast.showToast(
              msg: allTranslations.text("deletefail"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0);
          yield ActivitySuccess(success: false);
        }
      } else {
        Fluttertoast.showToast(
            msg: allTranslations.text("deletefail"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        yield ActivitySuccess(success: false);
      }
    }
  }
}
