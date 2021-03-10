class SingleOrderByOrder {
  String oderNos;
  String contactCode;
  String dCNo;

  set setoderNos(String value) => oderNos = value;

  set setcontactCode(String value) => contactCode = value;

  set setdCNo(String value) => dCNo = value;

  SingleOrderByOrder();

  Map toJson() {
    Map map = new Map();
    map["OrderNos"] = oderNos;
    map["ContactCode"] = contactCode;
    map["DCNo"] = dCNo;
    return map;
  }
}
