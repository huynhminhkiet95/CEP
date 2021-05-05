import 'dart:async';
import 'dart:core';

import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/blocs/community_development/community_development_state.dart';
import 'package:CEPmobile/database/DBProvider.dart';
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

import 'community_development_event.dart';

class CommunityDevelopmentBloc extends BlocEventStateBase<CommunityDevelopmentEvent, CommunityDevelopmentState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  CommunityDevelopmentBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: CommunityDevelopmentState.init());



  @override
  void dispose() {
    //_getSurveyController?.close();
    super.dispose();
  }

  @override
  Stream<CommunityDevelopmentState> eventHandler(
      CommunityDevelopmentEvent event, CommunityDevelopmentState state) async* {
    if (event is LoadCommunityDevelopmentEvent) {
      // SurveyStream surveyStream = new SurveyStream();
      // HistorySearchSurvey historySearch;
      // yield CommunityDevelopmentState.updateLoading(true);
      // List<HistorySearchCommunityDevelopment> listHistorySearch =
      //     await DBProvider.db.getAllHistorySearchKhaoSat();

      // if (listHistorySearch.length > 0) {
      //   if (globalUser.getCumId == null) {
      //     historySearch = listHistorySearch.last;
      //   } else {
      //     historySearch = listHistorySearch
      //         .where((e) => e.cumID == globalUser.getCumId)
      //         .first;
      //   }
      //   surveyStream.cumID = globalUser.getCumId == null
      //       ? listHistorySearch.last.cumID
      //       : historySearch.cumID;
      //   surveyStream.ngayXuatDS = globalUser.getCumId == null
      //       ? listHistorySearch.last.ngayXuatDanhSach
      //       : historySearch.ngayXuatDanhSach;
      // }

      // List<SurveyInfo> listSurvey = await DBProvider.db.getAllKhaoSat();
      // List<SurveyInfoHistory> listSurveyInfoHistory =
      //     await DBProvider.db.getAllLichSuKhaoSat();
      // surveyStream.listHistorySearch = listHistorySearch;
      // if (surveyStream.listHistorySearch.length > 0) {
      //    surveyStream.listSurvey = listSurvey
      //     .where((e) => e.idHistoryKhaoSat == historySearch.id ?? 0)
      //     .toList();
      //     globalUser.setListSurveyGlobal = listSurvey;
      // }

      // surveyStream.listSurveyInfoHistory = listSurveyInfoHistory;
      // yield CommunityDevelopmentState.updateLoading(false);
    }
    
  }
}
