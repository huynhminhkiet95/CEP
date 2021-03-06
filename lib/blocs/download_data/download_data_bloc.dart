import 'dart:convert';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/config/status_code.dart';
import 'package:CEPmobile/config/toast_result_message.dart';
import 'package:CEPmobile/database/DBProvider.dart';
import 'package:CEPmobile/models/community_development/comunity_development.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/models/download_data/survey_info_history.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
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
    if (event is DownloadDataSurveyEvent) {
      yield DownloadDataState.updateLoading(true);
      var response = await commonService.downloadDataSurvey(
          event.chiNhanhID, event.cumID, event.ngayxuatDS, event.masoql);

      var responseSurveyHistory =
          await commonService.downloadDataSurveyHistoryForTBDD(
              event.chiNhanhID, event.cumID, event.ngayxuatDS, event.masoql);

      if (response == null || responseSurveyHistory == null) {
        yield DownloadDataState.updateLoading(false);
          ToastResultMessage.error(allTranslations.text("NetworkSlow"));
      } else {
        if (response.statusCode == StatusCodeConstants.OK) {
          var jsonBody = json.decode(response.body);
          if (jsonBody["isSuccessed"]) {
            if (jsonBody["data"] != null && jsonBody["data"].length > 0) {
              int idHistoryKhaoSat = await DBProvider.db
                  .newHistorySearchKhaoSat(event.cumID, event.ngayxuatDS,
                      globalUser.getUserName, event.masoql);
              for (var item in jsonBody["data"]) {
                var listKhaoSat = SurveyInfo.fromJson(item);
                listKhaoSat.idHistoryKhaoSat = idHistoryKhaoSat;
                await DBProvider.db.newKhaoSat(listKhaoSat);
              }
              this.sharePreferenceService.saveCumId(event.cumID);
              ToastResultMessage.success(
                  allTranslations.text("DownLoadDataSuccess"));
            } else {
              ToastResultMessage.info("Kh??ng c?? d??? li???u ????? download !");
            }
            yield DownloadDataState.updateLoading(false);
          } else {
            ToastResultMessage.error(allTranslations.text("ServerNotFound"));
            yield DownloadDataState.updateLoading(false);
          }
        } else {
          yield DownloadDataState.updateLoading(false);
          ToastResultMessage.error(allTranslations.text("ServerNotFound"));
        }

        if (responseSurveyHistory.statusCode == StatusCodeConstants.OK) {
          var jsonBody = json.decode(responseSurveyHistory.body);
          if (jsonBody["isSuccessed"]) {
            if (jsonBody["data"] != null || !jsonBody["data"].isEmpty) {
              for (var item in jsonBody["data"]) {
                var listKhaoSat = SurveyInfoHistory.fromJson(item);
                await DBProvider.db.newLichSuKhaoSat(listKhaoSat);
              }
              // ToastResultMessage.success(
              //     allTranslations.text("DownLoadDataSuccess"));
            }
            yield DownloadDataState.updateLoading(false);
          } else {
            ToastResultMessage.error(
                allTranslations.text("DownLoadDataSurveyHistoryFailed"));
            yield DownloadDataState.updateLoading(false);
          }
        } else {
          yield DownloadDataState.updateLoading(false);
          ToastResultMessage.error(allTranslations.text("ServerNotFound"));
        }
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
            globalUser.setListComboboxModel = listCombobox;
            await DBProvider.db.newMetaDataForTBD(listCombobox);
            ToastResultMessage.success(
                allTranslations.text("DownLoadDataSuccess"));
          }
          yield DownloadDataState.updateLoading(false);
        } else {
          ToastResultMessage.error(allTranslations.text("ServerNotFound"));
          yield DownloadDataState.updateLoading(false);
        }
      } else {
        yield DownloadDataState.updateLoading(false);
        ToastResultMessage.error(allTranslations.text("ServerNotFound"));
      }
    } else if (event is DownloadDataCommunityDevelopmentEvent) {
      yield DownloadDataState.updateLoading(true);
      var response = await commonService.downloadDataCommunityDevelopment(
          globalUser.getUserInfo.chiNhanhID,
          event.cumID,
          globalUser.getUserInfo.masoql);
      if (response.statusCode == StatusCodeConstants.OK) {
        var jsonBody = json.decode(response.body);
        if (jsonBody["isSuccessed"]) {
          if (jsonBody["data"] != null || !jsonBody["data"].isEmpty) {
            List<KhachHang> listCustomer = new List<KhachHang>();

            for (var item in jsonBody["data"]) {
              KhachHang khachhang = KhachHang.fromJson(item);
              listCustomer.add(khachhang);
            }
            await DBProvider.db.newCommunityDevelopment(listCustomer);
            this
                .sharePreferenceService
                .saveCumIdOfCommunityDevelopment(event.cumID);
            ToastResultMessage.success(
                allTranslations.text("DownLoadDataSuccess"));
          }
          yield DownloadDataState.updateLoading(false);
        } else {
          ToastResultMessage.info("Kh??ng c?? d??? li???u ????? download !");
          yield DownloadDataState.updateLoading(false);
        }
      } else {
        yield DownloadDataState.updateLoading(false);
        ToastResultMessage.error(allTranslations.text("ServerNotFound"));
      }
    }
  }
}
