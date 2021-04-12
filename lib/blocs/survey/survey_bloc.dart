import 'dart:async';
import 'dart:core';

import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/config/status_code.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/models/download_data/survey_info_history.dart';
import 'package:CEPmobile/models/survey/survey_result.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:CEPmobile/blocs/survey/survey_state.dart';
import 'package:CEPmobile/blocs/survey/survey_event.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

class SurveyBloc extends BlocEventStateBase<SurveyEvent, SurveyState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  SurveyBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: SurveyState.init());

  // BehaviorSubject<List<SurveyInfo>> _getSurveyController =
  //     BehaviorSubject<List<SurveyInfo>>();
  // Stream<List<SurveyInfo>> get getSurveys => _getSurveyController;

  // BehaviorSubject<List<HistorySearchSurvey>> _getHistorySurveyController =
  //     BehaviorSubject<List<HistorySearchSurvey>>();
  // Stream<List<HistorySearchSurvey>> get getHistorySurvey => _getHistorySurveyController;

  // BehaviorSubject<List<ComboboxModel>> _getComboboxController =
  //     BehaviorSubject<List<ComboboxModel>>();
  // Stream<List<ComboboxModel>> get getCombobox => _getComboboxController;

  BehaviorSubject<SurveyStream> _getSurveyStreamController =
      BehaviorSubject<SurveyStream>();
  Stream<SurveyStream> get getSurveyStream => _getSurveyStreamController;

  @override
  void dispose() {
    //_getSurveyController?.close();
    super.dispose();
  }

  @override
  Stream<SurveyState> eventHandler(
      SurveyEvent event, SurveyState state) async* {
    if (event is LoadSurveyEvent) {
      SurveyStream surveyStream = new SurveyStream();
      yield SurveyState.updateLoading(true);
      var listHistorySearch = await DBProvider.db.getAllHistorySearchKhaoSat();
      List<SurveyInfo> listSurvey = await DBProvider.db.getAllKhaoSat();
      List<SurveyInfoHistory> listSurveyInfoHistory = await DBProvider.db.getAllLichSuKhaoSat();
      surveyStream.listHistorySearch = listHistorySearch;
      surveyStream.listSurvey = listSurvey;
      surveyStream.listSurveyInfoHistory = listSurveyInfoHistory;
      globalUser.setListSurveyGlobal = listSurvey;
      _getSurveyStreamController.sink.add(surveyStream);
      yield SurveyState.updateLoading(false);
    }
    if (event is UpdateSurveyEvent) {
      yield SurveyState.updateLoading(true);
      int rs = await DBProvider.db.updateKhaoSatById(event.surveyInfo);
      List<SurveyInfo> listSurvey = await DBProvider.db.getAllKhaoSat();
      globalUser.setListSurveyGlobal = listSurvey;

      Timer(Duration(milliseconds: 1000), () {
        Navigator.pop(event.context, listSurvey);
        if (rs > 0) {
          Fluttertoast.showToast(
            msg: allTranslations.text("UpdateSurveyInfoSuccessfully"),
            timeInSecForIos: 10,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
            backgroundColor: Colors.green[600].withOpacity(0.9),
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
              msg: allTranslations.text("Savefail"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
    if (event is UpdateSurveyToServerEvent) {
      yield SurveyState.updateLoadingSaveData(true);
      List<SurveyInfo> listSurveyUpdate;
      var listCheckBox = event.listCheckBox
          .where((e) => e.status == true)
          .map((e) => e.id)
          .toList();
      List<SurveyInfo> listSurvey = await DBProvider.db.getAllKhaoSat();
      listSurveyUpdate =
          listSurvey.where((e) => listCheckBox.contains(e.id)).toList();
      //String jsonbody = json.encode(listSurveyUpdate);

      var response = await commonService.updateSurveyInfo(listSurveyUpdate);
      if (response.statusCode == StatusCodeConstants.OK) {
        var jsonBody = json.decode(response.body);
        if (jsonBody["isSuccessed"]) {
          if (jsonBody["data"] != null || !jsonBody["data"].isEmpty) {
            Fluttertoast.showToast(
              msg: jsonBody["message"],
              timeInSecForIos: 10,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
              backgroundColor: Colors.green[600].withOpacity(0.9),
              textColor: Colors.white,
            );
          }
          yield SurveyState.updateLoadingSaveData(false);
        }
      } else {
        yield SurveyState.updateLoadingSaveData(false);
        Fluttertoast.showToast(
          msg: allTranslations.text("ServerNotFound"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
          backgroundColor: Colors.red[300].withOpacity(0.7),
          textColor: Colors.white,
        );
      }
      print(listSurvey);
      yield SurveyState.updateLoadingSaveData(false); //
    }
  }
}
