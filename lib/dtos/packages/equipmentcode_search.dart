class EquipmentCodeSearch {
  String dCCode;
  String equipTypeNo;
  String equipmentCode;
  String equipmentDesc;
  String ownership;
  String assetCode;
  String serialNumber;

  Map toJson() {
    Map map = new Map();
    map["DCCode"] = dCCode;
    map["EquipTypeNo"] = equipTypeNo;
    map["EquipmentCode"] = equipmentCode;
    map["EquipmentDesc"] = equipmentDesc;
    map["Ownership"] = ownership;
    map["AssetCode"] = assetCode;
    map["SerialNumber"] = serialNumber;
    return map;
  }

  EquipmentCodeSearch();
}
