class ReceiptPackageEntry {
  String packageNo;
  String receiptDate;
  String equipmentCode;
  String driverName;
  String createUser;
  String currentLocNo;
  String lastMoveDate;
  String packageMemo;
  String refNo;
  String receptType;
  String contactCode;
  String dCCode;

  Map toJson() {
    Map map = new Map();
    map["PackageNo"] = packageNo;
    map["ReceiptDate"] = receiptDate;
    map["EquipmentCode"] = equipmentCode;
    map["DriverName"] = driverName;
    map["CreateUser"] = createUser;
    map["CurrentLocNo"] = currentLocNo;
    map["LastMoveDate"] = lastMoveDate;
    map["PackageMemo"] = packageMemo;
    map["RefNo"] = refNo;
    map["ReceptType"] = receptType;
    map["ContactCode"] = contactCode;
    map["DCCode"] = dCCode;
    return map;
  }

  ReceiptPackageEntry();
}
