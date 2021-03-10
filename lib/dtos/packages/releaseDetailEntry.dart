class ReleaseDetailEntry {
  int pKGReId;
  String contactCode;
  String dCCode;
  String moveDate;
  String equipmentCode;
  String driverName;
  String packageNo;
  String createUser;

  Map toJson() {
    Map map = new Map();
    map["PKGReId"] = pKGReId;
    map["ContactCode"] = contactCode;
    map["DCCode"] = dCCode;
    map["MoveDate"] = moveDate;
    map["EquipmentCode"] = equipmentCode;
    map["DriverName"] = driverName;
    map["PackageNo"] = packageNo;
    map["CreateUser"] = createUser;
    return map;
  }

  ReleaseDetailEntry();
}
