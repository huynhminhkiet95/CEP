class UserInfoPwdJsonResult {
  //String token;
  //String nextCloudToken;
  UserInfo userInfo;
  //StaffInfo staffInfo;
  SystemInfo systemInfo;

  UserInfoPwdJsonResult({this.userInfo, this.systemInfo});

  factory UserInfoPwdJsonResult.fromJson(Map<String, dynamic> jsondata) {
    var _userInfo = new UserInfo();
    _userInfo = UserInfo.fromJson(jsondata);
    // var _staffInfo = new StaffInfo();
    // _staffInfo = StaffInfo.fromJson(jsondata);
     var _systemInfo = new SystemInfo();
    _systemInfo = SystemInfo.fromJson(jsondata);

    return UserInfoPwdJsonResult(userInfo: _userInfo, systemInfo: _systemInfo);
  }
}

class UserInfo {
  String subsidiaryId;
  String subsidiaryName;
  String employeeName;
  int idIssueDate;
  String nationality;
  String nativePlace;
  String lastEducationName;
  String permanentAddress;
  String mobile;

  UserInfo(
      {this.subsidiaryId,
      this.subsidiaryName,
      this.employeeName,
      this.idIssueDate,
      this.nationality,
      this.nativePlace,
      this.mobile,
      this.lastEducationName,
      this.permanentAddress,
      });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      subsidiaryId: json['payload']['userDetail']['subsidiaryId'] as String?? '',
      subsidiaryName: json['payload']['userDetail']['subsidiaryName'] as String?? '',
      employeeName: json['payload']['userDetail']['employeeName'] as String?? '',
      nationality: json['payload']['userDetail']['nationality'] as String?? '',
      nativePlace: json['payload']['userDetail']['nativePlace'] as String?? '',
      lastEducationName: json['payload']['userDetail']['lastEducationName'] as String?? '',
      permanentAddress: json['payload']['userDetail']['permanentAddress'] as String?? '',
      mobile: json['payload']['userDetail']['mobile'] as String?? '',
    );
  }
}

class StaffInfo {
  String staffName;
  int staffId;
  String fleetdesc;

  StaffInfo({this.staffName, this.staffId, this.fleetdesc});

  factory StaffInfo.fromJson(Map<String, dynamic> json) {
    return StaffInfo(
      staffId: json['payload']['staffID'] as int,
      staffName: json['payload']['staffName'] as String ?? '',
      fleetdesc: json['payload']['fleet_Desc'] as String ?? '',
    );
  }
}

class SystemInfo {
  String systemId;
  String systemName;
  String notificationUrl;
  String inspectionUrl;

  SystemInfo({this.systemId, this.systemName, this.notificationUrl, this.inspectionUrl});

  factory SystemInfo.fromJson(Map<String, dynamic> json) {
    return SystemInfo(
      systemId: json['payload']['systemInfo']['systemId'] as String ?? '',
      systemName: json['payload']['systemInfo']['systemName'] as String ?? '',
      notificationUrl: json['payload']['systemInfo']['notificationUrl'] as String ?? '',
      inspectionUrl: json['payload']['systemInfo']['inspectionUrl'] as String ?? '',
    );
  }
}
