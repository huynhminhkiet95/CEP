import 'dart:async';

import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/models/survey/survey_result.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:CEPmobile/blocs/survey/survey_state.dart';
import 'package:CEPmobile/blocs/survey/survey_event.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

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
      surveyStream.listHistorySearch = listHistorySearch;
      surveyStream.listSurvey = listSurvey;
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
  }
}
