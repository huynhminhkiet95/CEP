import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/blocs/todolist/triptodo_event.dart';
import 'package:CEPmobile/blocs/todolist/triptodo_state.dart';
import 'package:CEPmobile/dtos/common/gettodobookings.dart';
import 'package:CEPmobile/dtos/common/saveAcceptTrip.dart';
import 'package:CEPmobile/models/comon/TripTodo.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import '../../GlobalTranslations.dart';
import '../../globalDriverProfile.dart';

class TripTodoBloc extends BlocEventStateBase<TripTodoEvent, TripTodoState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  TripTodoBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: TripTodoState.init());

  BehaviorSubject<List<TripTodo>> _getTripTodoController =
      BehaviorSubject<List<TripTodo>>();
  Stream<List<TripTodo>> get getTriptodo => _getTripTodoController;

  @override
  void dispose() {
    //_getTripTodoController?.close();
    super.dispose();
  }

  @override
  Stream<TripTodoState> eventHandler(
      TripTodoEvent event, TripTodoState state) async* {
    if (event is LoadTripTodoEvent) {
      yield TripTodoState.updateLoading(true);
      GetTodoBookings data = new GetTodoBookings();
      data.todoDate = formatDate(new DateTime.now(), [yyyy, '', mm, '', dd]);
      data.equipment = globalDriverProfile.getfleet;
      var response =
          await commonService.getTodoBookings(data, globalUser.getSubsidiaryId);

      if (response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        var tripTodoJson =
            dataJson["payload"].cast<Map<String, dynamic>>() as List;
        if (tripTodoJson.length > 0) {
          var tripTodo = tripTodoJson
              .map<TripTodo>((json) => TripTodo.fromJson(json))
              .toList();
          if (!_getTripTodoController.isClosed)
            _getTripTodoController.sink.add(tripTodo);
        } else {
          if (_getTripTodoController?.isClosed != true) {
            _getTripTodoController.sink.add(null);
          }
        }
      }
      yield TripTodoState.updateLoading(false);
    }

    if (event is UpdateTripAccept) {
      yield TripTodoState.updateLoading(true);
      SaveAcceptTrip data = new SaveAcceptTrip();
      data = event.saveAcceptTrip;
      var response =
          await commonService.saveAcceptTrip(data, globalUser.getSubsidiaryId);
      if (response != null && response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        //var tripTodoJson = dataJson["payload"].cast<Map<String, dynamic>>() as int;
        Fluttertoast.showToast(
            msg: allTranslations.text("Acceptsuccess"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: 16.0);

        await emitEvent(LoadTripTodoEvent());
      }

      yield TripTodoState.updateLoading(false);
    }

    if (event is UpdateTripPickup) {
      yield TripTodoState.updateLoading(true);
      var data = event.savePickUpTrip;
      var response =
          await commonService.savePickUpTrip(data, globalUser.getSubsidiaryId);
      if (response != null && response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        if (dataJson["success"] == true) {
          Fluttertoast.showToast(
              msg: allTranslations.text("PickupSuccess"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        await emitEvent(LoadTripTodoEvent());
      }

      yield TripTodoState.updateLoading(false);
    }
  }
}
