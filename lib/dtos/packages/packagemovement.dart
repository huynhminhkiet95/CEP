class PackageMovement {
  String packageNo;
  String moveDate;
  String createUser;
  String toLocNo;
  String packageMemo;
  String contactCode;
  String dCCode;

  Map toJson() {
    Map map = new Map();
    map["PackageNo"] = packageNo;
    map["MoveDate"] = moveDate;
    map["CreateUser"] = createUser;
    map["ToLocNo"] = toLocNo;
    map["PackageMemo"] = packageMemo;
    map["ContactCode"] = contactCode;
    map["DCCode"] = dCCode;
    return map;
  }

  PackageMovement();
}
