class UserProfileDTO {
  String userId;
  String userName;
  String email;
  String mobileNo;
  String language;
  String defaultSystem;
  String defaultSubsidiary;
  String defaultContact;
  String defaultDC;
  String defaultBarnch;
  String updateUser;

  Map toJson() {
    Map map = new Map();
    map["UserId"] = userId;
    map["UserName"] = userName;
    map["Email"] = email;
    map["MobileNo"] = mobileNo;
    map["Language"] = language;
    map["DefaultSystem"] = defaultSystem;
    map["DefaultSubsidiary"] = defaultSubsidiary;
    map["DefaultContact"] = defaultContact;
    map["DefaultDC"] = defaultDC;
    map["DefaultBarnch"] = defaultBarnch;
    map["UpdateUser"] = updateUser;

    return map;
  }

  UserProfileDTO();
}
