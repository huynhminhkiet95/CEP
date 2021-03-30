import 'dart:convert';

import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/config/status_code.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/download_data/client.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:CEPmobile/blocs/download_data/download_data_event.dart';
import 'package:CEPmobile/blocs/download_data/download_data_state.dart';

class DownloadDataBloc
    extends BlocEventStateBase<DownloadDataEvent, DownloadDataState> {
  final SharePreferenceService sharePreferenceService;
  final CommonService commonService;

  DownloadDataBloc(this.sharePreferenceService, this.commonService)
      : super(initialState: DownloadDataState.init());

  // BehaviorSubject<List<SurveyInfo>> _getDownloadDataController =
  //     BehaviorSubject<List<SurveyInfo>>();
  // Stream<List<SurveyInfo>> get getDownloadDatas => _getDownloadDataController;

  @override
  void dispose() {
    //_getDownloadDataController?.close();
    super.dispose();
  }

  @override
  Stream<DownloadDataState> eventHandler(
      DownloadDataEvent event, DownloadDataState state) async* {
    if (event is LoadDownloadDataEvent) {
      yield DownloadDataState.updateLoading(true);
      var response = await commonService.downloadDataSurvey(
          event.chiNhanhID, event.cumID, event.ngayxuatDS, event.masoql);
      if (response.statusCode == StatusCodeConstants.OK) {
        var jsonBody = json.decode(response.body);
        if (jsonBody["isSuccessed"]) {
          int idHistoryKhaoSat = await DBProvider.db.newHistorySearchKhaoSat(
              event.cumID,
              event.ngayxuatDS,
              globalUser.getUserName,
              event.masoql);
          if (jsonBody["data"] != null || !jsonBody["data"].isEmpty) {
            for (var item in jsonBody["data"]) {
              var listKhaoSat = SurveyInfo.fromJson(item);
              listKhaoSat.idHistoryKhaoSat = idHistoryKhaoSat;
              await DBProvider.db.newKhaoSat(listKhaoSat);
            }
            Fluttertoast.showToast(
              msg: allTranslations.text("DownLoadDataSuccess"),
              timeInSecForIos: 10,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
              backgroundColor: Colors.green[600].withOpacity(0.9),
              textColor: Colors.white,
            );
          }
          yield DownloadDataState.updateLoading(false);
        } else {
          Fluttertoast.showToast(
            msg: allTranslations.text("ServerNotFound"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
            backgroundColor: Colors.red[300].withOpacity(0.7),
            textColor: Colors.white,
          );
          yield DownloadDataState.updateLoading(false);
        }
      } else {
        yield DownloadDataState.updateLoading(false);
        Fluttertoast.showToast(
          msg: allTranslations.text("ServerNotFound"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
          backgroundColor: Colors.red[300].withOpacity(0.7),
          textColor: Colors.white,
        );
      }
    } else if (event is DownloadDataComboBoxEvent) {
      yield DownloadDataState.updateLoading(true);
      var response = await commonService.downloadDataComboBox();
      if (response.statusCode == StatusCodeConstants.OK) {
        var jsonBody = json.decode(response.body);
        if (jsonBody["isSuccessed"]) {
          if (jsonBody["data"] != null || !jsonBody["data"].isEmpty) {
            List<ComboboxModel> listCombobox = new List<ComboboxModel>();
            for (var item in jsonBody["data"]) {
              var listKhaoSat = ComboboxModel.fromJson(item);
              listCombobox.add(listKhaoSat);
            }
            await DBProvider.db.newMetaDataForTBD(listCombobox);
            Fluttertoast.showToast(
              msg: allTranslations.text("DownLoadDataSuccess"),
              timeInSecForIos: 10,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
              backgroundColor: Colors.green[600].withOpacity(0.9),
              textColor: Colors.white,
            );
          }
          yield DownloadDataState.updateLoading(false);
        } else {
          Fluttertoast.showToast(
            msg: allTranslations.text("ServerNotFound"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
            backgroundColor: Colors.red[300].withOpacity(0.7),
            textColor: Colors.white,
          );
          yield DownloadDataState.updateLoading(false);
        }
      } else {
        yield DownloadDataState.updateLoading(false);
        Fluttertoast.showToast(
          msg: allTranslations.text("ServerNotFound"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
          backgroundColor: Colors.red[300].withOpacity(0.7),
          textColor: Colors.white,
        );
      }
    }
  }
}
