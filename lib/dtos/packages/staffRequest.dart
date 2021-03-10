class StaffRequest {
  String dCCode;
  String staffName;
  String staffUserId;
  String roleType;
  String mobileNo;

  Map toJson() {
    Map map = new Map();
    map["DCCode"] = dCCode;
    map["StaffName"] = staffName;
    map["StaffUserId"] = staffUserId;
    map["RoleType"] = roleType;
    map["MobileNo"] = mobileNo;
    return map;
  }

  StaffRequest();
}
