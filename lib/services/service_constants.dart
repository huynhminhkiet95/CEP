mixin ServiceName {
  static const String Get_ValidateUser = "api/authentication/validateuser";
  static const String Get_Token = "api/NhanVien/Login";
  static const String GetUserInfo = "api/NhanVien/GetUsers?UserName=%s";
  static const String GetUserRoles = "api/NhanVien/GetUserRoles?UserName=%s";
  static const String GetSurveyInfo = "api/NhanVien/LayThongTinKhaoSat";
  static const String GetComboBoxValueChoTBD = "api/NhanVien/GetComboBoxValueChoTBĐ";

  static const String Get_PageMenuPermission = "/api/ssocommonservice/menus";
  static const String Get_UserProfile = "api/authentication/userprofile/";
  static const String Get_TodoBookings = "api/etp/booking/gettodobooking";
  static const String GetFleetMile = "api/etp/fleet/getfleetmile";
  static const String SaveAcceptTrip = "api/etp/booking/saveaccepttrip";
  static const String SaveBookTripRecord = "api/etp/booking/savebooktriprecord";
  static const String SaveDayTripRecord = "api/etp/support/savedaytriprecord";
  static const String UploadDocument =
      "MB2/MbSvc2.svc/UploadDocument?subsidiaryId=%s";
  static const String Savefleettracking = "api/etp/fleet/savefleettracking";
  static const String GetEmployeePrivate = "api/userprofile/getemployeeprivate";
  static const String Getaprrovetriprecords =
      "api/etp/support/getaprrovetriprecords";
  static const String Deletetriprecord = "api/etp/support/deletetriprecord";
  static const String Get_Triprecordsmobileapp =
      "api/etp/support/gettriprecordsmobileapp";
  static const String Get_CheckLists = "api/etp/support/getchecklistinspection";
  static const String Get_Notifications = "api/GetMessage/";
  static const String Get_TotalNotifications = "api/CountMessageByUser/";
  static const String Update_Notifications = "api/UpdateMsgStatus";
  static const String Delete_Notifications = "api/DeleteMessage/";
  static const String Getlastedversion =
      "api/ssocommonservice/getlastedversion/MB_ENT";
  static const String GetAnnouncements = "api/etp/announcement/getformobile/";
  static const String SaveAnnouncementEndorse =
      "api/etp/announcement/insertendorse";
  static const String Get_staffinfo = "api/etp/staff/getstaffinfo/?id=%s";
  static const String SaveImage = "api/document/saveimage";
  static const String GetDocuments = "api/document/getdocuments";
  static const String DeleteDocument = "api/document/deletedocument";
}
