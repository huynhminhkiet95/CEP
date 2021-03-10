class SimpleTripEntry {
  String eTP;
  String eTA;
  String eTD;
  String createUser;
  String equipmentCode;
  String equipmentDesc;
  String driverDesc;
  String driverId;
  String aTP;
  String completeTime;
  String tripStatus;
  String dCCode;
  String tripMemo;
  String equipTypeNo;
  String orderIds;

  set seteTP(String value) => eTP = value;

  set seteTA(String value) => eTA = value;

  set seteTD(String value) => eTD = value;

  set setcreateUser(String value) => createUser = value;

  set setequipmentCode(String value) => equipmentCode = value;

  set setequipmentDesc(String value) => equipmentDesc = value;

  set setdriverId(String value) => driverId = value;

  set setaTP(String value) => aTP = value;

  set setdriverDesc(String value) => driverDesc = value;

  set setcompleteTime(String value) => completeTime = value;

  set settripStatus(String value) => tripStatus = value;

  set setdCCode(String value) => dCCode = value;

  set settripMemo(String value) => tripMemo = value;

  set setequipTypeNo(String value) => equipTypeNo = value;

  set setorderIds(String value) => orderIds = value;

  SimpleTripEntry();

  Map toJson() {
    Map map = new Map();
    map["ETP"] = eTP;
    map["ETA"] = eTA;
    map["ETD"] = eTD;
    map["CreateUser"] = createUser;
    map["EquipmentCode"] = equipmentCode;
    map["EquipmentDesc"] = equipmentDesc;
    map["DriverDesc"] = driverDesc;
    map["DriverId"] = driverId;
    map["ATP"] = aTP;
    map["CompleteTime"] = completeTime;
    map["TripStatus"] = tripStatus;
    map["DCCode"] = dCCode;
    map["TripMemo"] = tripMemo;
    map["EquipTypeNo"] = equipTypeNo;
    map["OrderIds"] = orderIds;
    return map;
  }
}
