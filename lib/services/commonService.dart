import 'dart:io';

import 'package:CEPmobile/dtos/announcement/announcementdto.dart';
import 'package:CEPmobile/dtos/common/getaprrovetriprecords.dart';
import 'package:CEPmobile/dtos/common/gettodobookings.dart';
import 'package:CEPmobile/dtos/common/saveAcceptTrip.dart';
import 'package:CEPmobile/dtos/common/savePickUpTrip.dart';
import 'package:CEPmobile/dtos/common/uploaddocument.dart';
import 'package:CEPmobile/dtos/datalogin.dart';
import 'package:CEPmobile/dtos/localdistributtion/daytriprecord.dart';
import 'package:CEPmobile/dtos/localdistributtion/triprecord.dart';
import 'package:CEPmobile/globalServer.dart';
import 'package:http/http.dart';
import 'package:sprintf/sprintf.dart';

import 'package:CEPmobile/dtos/UserLogin.dart';
import 'package:CEPmobile/httpProvider/HttpProviders.dart';
import 'package:CEPmobile/services/service_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../GlobalUser.dart';
import '../globalDriverProfile.dart';

class CommonService {
  final HttpBase _httpBase;
  CommonService(this._httpBase);

  Future<Response> getUser(UserLogin userInfo) {
    return _httpBase.httpPostToken(ServiceName.Get_ValidateUser.toString(), userInfo.toJson());
  }

  Future<Response> getToken(DataLogin datalogin) {
    return _httpBase.postRequest(ServiceName.Get_Token.toString(), datalogin.toJson());
  }

  Future<Response> getGetUser(String userName) {
    return _httpBase.httpGetToken(sprintf(ServiceName.GetUserInfo.toString(),[userName]));
  }

  Future<Response> getUserRoles(String userName) {
    return _httpBase.httpGetToken(sprintf(ServiceName.GetUserRoles.toString(),[userName]));
  }

  Future<Response> getEmployeePrivate(String employeeId, String systemId) {
    Map map = new Map();
    map["EmployeeId"] = employeeId;
    map["SystemId"] = systemId;
    return _httpBase.httpPostSSO(ServiceName.GetEmployeePrivate.toString(), map);
  }

  Future<Response> getMenuPermission(
      String userId, String systemId, String subsidiaryId) {
    Map map = new Map();
    map["UserID"] = userId;
    map["SystemId"] = systemId;
    map["PlatformId"] = 'MB_ENT';
    map["SubsidiaryId"] = subsidiaryId;
    return _httpBase.httpPostSSO(
        ServiceName.Get_PageMenuPermission.toString(), map);
  }

  Future<Response> getUserProfile(int id) {
    var url = ServiceName.Get_UserProfile.toString() + id.toString();
    return _httpBase.httpGetToken(url);
  }

  Future<Response> saveTriprecord(TripRecord triprecord, String subsidiaryId) {
    var url =
        sprintf(ServiceName.SaveBookTripRecord.toString(), [subsidiaryId, '']);
    return _httpBase.httpPostToken(url, triprecord.toJson());
  }

  Future<Response> saveDayTriprecord(
      DayTripRecord triprecord, String subsidiaryId) {
    var url =
        sprintf(ServiceName.SaveDayTripRecord.toString(), [subsidiaryId, '']);
    return _httpBase.httpPostToken(url, triprecord.toJson());
  }

  Future<Response> getLastestMileage(
      String equipmentCode, String subsidiaryId) {
    var url = sprintf(
        ServiceName.GetFleetMile.toString(), [equipmentCode, subsidiaryId]);
    return _httpBase.httpPostToken(url, {"FleetDesc": "$equipmentCode"});
  }

  Future<Response> getTodoBookings(
      GetTodoBookings gettodobookings, String subsidiaryId) {
    var url =
        sprintf(ServiceName.Get_TodoBookings.toString(), [subsidiaryId, '']);
    return _httpBase.httpPostToken(url, gettodobookings);
  }

  Future<Response> getAnnouncements(int userId) {
    var url = ServiceName.GetAnnouncements.toString() + userId.toString();
    return _httpBase.httpGetToken(url);
  }

  Future<Response> saveAnnouncementEndorse(
      SaveAnnouncementEndorse saveAnnouncementEndorse) {
    var url = ServiceName.SaveAnnouncementEndorse.toString();
    return _httpBase.httpPostToken(url, saveAnnouncementEndorse);
  }

  Future<Response> saveAcceptTrip(SaveAcceptTrip data, String subsidiaryId) {
    var url =
        sprintf(ServiceName.SaveAcceptTrip.toString(), [subsidiaryId, '']);
    return _httpBase.httpPostToken(url, data);
  }

  Future<Response> uploadDocument(
      UploadDocumentEntry uploadDocumentEntry, String subsidiaryId) {
    var url =
        sprintf(ServiceName.UploadDocument.toString(), [subsidiaryId, ""]);
    return _httpBase.httpPost(url, uploadDocumentEntry.toJson());
  }

  Future<Response> savePickUpTrip(SavePickUpTrip data, String subsidiaryId) {
    var url =
        sprintf(ServiceName.Savefleettracking.toString(), [subsidiaryId, '']);
    return _httpBase.httpPostToken(url, data);
  }

  Future<Response> getaprrovetriprecords(
      Getaprrovetriprecords getaprrovetriprecords, String subsidiaryId) {
    var url = sprintf(
        ServiceName.Get_Triprecordsmobileapp.toString(), [subsidiaryId, '']);
    return _httpBase.httpPostToken(url, getaprrovetriprecords);
  }

  Future<Response> deletetriprecord(int id, int userId, String subsidiaryId) {
    Map map = new Map();
    map["TRId"] = id;
    map["updateUser"] = userId;
    var url =
        sprintf(ServiceName.Deletetriprecord.toString(), [subsidiaryId, '']);
    return _httpBase.httpPostToken(url, map);
  }

  Future<Response> getCheckList(
      String fromdate, String todate, String equipmentCode, int userId) {
    Map map = new Map();
    map["CheckDateF"] = fromdate;
    map["CheckDateT"] = todate;
    map["equipmentCode"] = equipmentCode;
    map["CreatedUser"] = userId;
    var url = sprintf(ServiceName.Get_CheckLists.toString(),
        [globalUser.getDefaultSubsidiary, '']);
    return _httpBase.httpPostToken(url, map);
  }

  Future<Response> getNotifications(
      String userId, String sourceType, String messageType) {
    var url = ServiceName.Get_Notifications.toString() +
        "$userId/$sourceType/$messageType";
    return _httpBase.httpGetHub(url);
  }

  Future<Response> countNotifications(String userId, String sourceType) {
    var url =
        ServiceName.Get_TotalNotifications.toString() + "$userId/$sourceType";
    return _httpBase.httpGetHub(url);
  }

  Future<Response> updateNotifications(
      String userId, String reqIds, String status) {
    Map map = new Map();
    map["Username"] = userId;
    map["ReqIds"] = reqIds;
    map["FinalStatusMessage"] = status;
    var url = sprintf(ServiceName.Update_Notifications.toString(),
        [globalUser.getDefaultSubsidiary, '']);
    return _httpBase.httpPostHub(url, map);
  }

  Future<Response> deleteNotifications(String strReqIds) {
    Map map = new Map();
    var url = sprintf(ServiceName.Delete_Notifications.toString() + strReqIds,
        [globalUser.getDefaultSubsidiary, '']);
    return _httpBase.httpPostHubNoBody(url, map);
  }

  Future<Response> getlastedversion() {
    var url = ServiceName.Getlastedversion.toString();
    return _httpBase.httpGetAsync(url);
  }

  Future<Response> getStaff(int id) {
    var url = sprintf(ServiceName.Get_staffinfo.toString(), [id, ""]);
    return _httpBase.httpGetToken(url);
  }

  static void goInspectionList(String type) async {
    if (await canLaunch('chrome://')) {
      await launch(
          globalServer.getServerInspection +
              'inspection?bookno=&driverid=${globalUser.getStaffId}&equimentcode=&userid=${globalUser.getId}&type=${type.toString()}',
          forceSafariVC: false);
    } else {
      await launch(
          globalServer.getServerInspection +
              'inspection?bookno=&driverid=${globalUser.getStaffId}&equimentcode=&userid=${globalUser.getId}&type=${type.toString()}',
          forceSafariVC: true);
    }
  }

  static void goInspectionListTrip(String type, bookno) async {
    if (await canLaunch('chrome://')) {
      await launch(
          globalServer.getServerInspection +
              'inspection?bookno=$bookno&driverid=${globalUser.getStaffId}&equimentcode=${globalDriverProfile.getfleet}&userid=${globalUser.getId}&type=${type.toString()}',
          forceSafariVC: false);
    } else {
      await launch(
          globalServer.getServerInspection +
              'inspection?bookno=$bookno&driverid=${globalUser.getStaffId}&equimentcode=${globalDriverProfile.getfleet}&userid=${globalUser.getId}&type=${type.toString()}',
          forceSafariVC: true);
    }
  }

  Future<StreamedResponse> saveImage(File file, int itemId) {
    return _httpBase.httpPostOpenalpr(file, itemId);
  }

  Future<Response> getDownloadData(int chiNhanhID, String cumID, String ngayxuatDS,String masoql) {
    Map map = new Map();
    map["chiNhanhID"] = chiNhanhID;
    map["cumID"] = cumID;
    map["ngayxuatDanhSach"] = ngayxuatDS;
    map["masoql"] = masoql;
    return _httpBase.httpPostToken(ServiceName.GetSurveyInfo.toString(), map);
  }
}
