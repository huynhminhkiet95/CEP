import 'dart:async';
import 'dart:core';

import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/config/status_code.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/community_development/comunity_development.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/models/download_data/survey_info_history.dart';
import 'package:CEPmobile/models/survey/survey_result.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:CEPmobile/blocs/survey/survey_state.dart';
import 'package:CEPmobile/blocs/survey/survey_event.dart';
import 'package:CEPmobile/ui/screens/community_development/community_development_detail.dart';
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
    _getSurveyStreamController?.close();
    super.dispose();
  }

  @override
  Stream<SurveyState> eventHandler(
      SurveyEvent event, SurveyState state) async* {
    if (event is LoadSurveyEvent) {
      SurveyStream surveyStream = new SurveyStream();
      HistorySearchSurvey historySearch;
      yield SurveyState.updateLoading(true);
      List<HistorySearchSurvey> listHistorySearch =
          await DBProvider.db.getAllHistorySearchKhaoSat();

      if (listHistorySearch.length > 0) {
        if (globalUser.getCumId == null) {
          historySearch = listHistorySearch.last;
        } else {
          historySearch = listHistorySearch
              .where((e) => e.cumID == globalUser.getCumId)
              .first;
        }
        surveyStream.cumID = globalUser.getCumId == null
            ? listHistorySearch.last.cumID
            : historySearch.cumID;
        surveyStream.ngayXuatDS = globalUser.getCumId == null
            ? listHistorySearch.last.ngayXuatDanhSach
            : historySearch.ngayXuatDanhSach;
      }

      List<SurveyInfo> listSurvey = await DBProvider.db.getAllKhaoSat();
      List<SurveyInfoHistory> listSurveyInfoHistory =
          await DBProvider.db.getAllLichSuKhaoSat();
      surveyStream.listHistorySearch = listHistorySearch;
      if (surveyStream.listHistorySearch.length > 0) {
        surveyStream.listSurvey = listSurvey
            .where((e) => e.idHistoryKhaoSat == historySearch.id ?? 0)
            .toList();
        globalUser.setListSurveyGlobal = listSurvey;
      }

      surveyStream.listSurveyInfoHistory = listSurveyInfoHistory;
      _getSurveyStreamController.sink.add(surveyStream);
      yield SurveyState.updateLoading(false);
    }
    if (event is SearchSurveyEvent) {
      SurveyStream surveyStream = new SurveyStream();
      String date = event.ngayXuatDanhSach;

      yield SurveyState.updateLoading(true);
      List<HistorySearchSurvey> listHistorySearch =
          await DBProvider.db.getAllHistorySearchKhaoSat();
      if (event.ngayXuatDanhSach == null) {
        date = listHistorySearch
            .where((e) => e.cumID == event.cumID)
            .first
            .ngayXuatDanhSach;
      }

      HistorySearchSurvey historySearch = listHistorySearch
          .where((e) => e.cumID == event.cumID && e.ngayXuatDanhSach == date)
          .first;
      List<SurveyInfo> listSurvey = await DBProvider.db.getAllKhaoSat();
      List<SurveyInfoHistory> listSurveyInfoHistory =
          await DBProvider.db.getAllLichSuKhaoSat();
      surveyStream.listHistorySearch = listHistorySearch;
      surveyStream.listSurvey = listSurvey
          .where((e) => e.idHistoryKhaoSat == historySearch.id)
          .toList();
      surveyStream.listSurveyInfoHistory = listSurveyInfoHistory;
      surveyStream.cumID = event.cumID;
      surveyStream.ngayXuatDS = date;
      globalUser.setListSurveyGlobal = listSurvey;
      _getSurveyStreamController.sink.add(surveyStream);

      this.sharePreferenceService.saveCumId(event.cumID);
      yield SurveyState.updateLoading(false);
    }
    if (event is UpdateSurveyEvent) {
      yield SurveyState.updateLoading(true);
      int rs = await DBProvider.db.updateKhaoSatById(event.surveyInfo);
      List<SurveyInfo> listSurvey = await DBProvider.db.getAllKhaoSat();
      globalUser.setListSurveyGlobal = listSurvey;

      Timer(Duration(milliseconds: 1000), () {
        if (rs > 0) {
          Navigator.pop(event.context, listSurvey);
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
    if (event is InsertNewCommunityDevelopment) {
      yield SurveyState.updateLoading(true);
      await DBProvider.db.newCommunityDevelopment(event.listKhachHang);

      List<KhachHang> listKhachHang;
      listKhachHang = await DBProvider.db.getCommunityDevelopmentByCum(
          event.listKhachHang.first.chinhanhId.toInt(),
          event.listKhachHang.first.masoql,
          event.listKhachHang.first.cumId);
      listKhachHang = listKhachHang
          .where((e) => e.maKhachHang == event.listKhachHang.first.maKhachHang)
          .toList();
      List<ComboboxModel> listCombobox = globalUser.getListComboboxModel;
      globalUser.setCumIdOfCommunityDevelopment = event.listKhachHang.first.cumId;

      Timer(Duration(milliseconds: 1000), () {
        Fluttertoast.showToast(
          msg: allTranslations.text("InsertCommunityDevelopmentSuccessfully"),
          timeInSecForIos: 10,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
          backgroundColor: Colors.green[600].withOpacity(0.9),
          textColor: Colors.white,
        );

        Navigator.pushNamed(event.context, 'comunitydevelopmentdetail',
            arguments: {
              'khachhang': listKhachHang[0],
              'metadata': listCombobox,
            });
      });
      yield SurveyState.updateLoading(false);
    }
  }
}
