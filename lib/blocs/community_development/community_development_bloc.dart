import 'dart:async';
import 'dart:core';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/blocs/community_development/community_development_state.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/community_development/comunity_development.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:rxdart/rxdart.dart';
import 'community_development_event.dart';

class CommunityDevelopmentBloc extends BlocEventStateBase<
    CommunityDevelopmentEvent, CommunityDevelopmentState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  CommunityDevelopmentBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: CommunityDevelopmentState.init());

  BehaviorSubject<List<KhachHang>> _getCommunityDevelopmentController =
      BehaviorSubject<List<KhachHang>>();
  Stream<List<KhachHang>> get getCommunityDevelopmentStream =>
      _getCommunityDevelopmentController;

  @override
  void dispose() {
    _getCommunityDevelopmentController?.close();
    super.dispose();
  }

  @override
  Stream<CommunityDevelopmentState> eventHandler(
      CommunityDevelopmentEvent event, CommunityDevelopmentState state) async* {
    if (event is LoadCommunityDevelopmentEvent) {
      // HistorySearchSurvey historySearch;
      yield CommunityDevelopmentState.updateLoading(true);
      List<KhachHang> listKhachHang;
      if (globalUser.getCumIdOfCommunityDevelopment != null) {
        listKhachHang = await DBProvider.db.getCommunityDevelopmentByCum(
            globalUser.getUserInfo.chiNhanhID,
            globalUser.getUserInfo.masoql,
            globalUser.getCumIdOfCommunityDevelopment);
      }
      _getCommunityDevelopmentController.sink.add(listKhachHang);
      yield CommunityDevelopmentState.updateLoading(false);
      
      //  communityDevelopmentStream.
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
      //yield CommunityDevelopmentState.updateLoading(false);
    }
  }
}
