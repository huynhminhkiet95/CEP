class Getaprrovetriprecords {
  String dateFrom;
  String dateTo;
  String bookingNo;
  String customerNo;
  String fleetDesc;
  String approvalStatus;
  String isUserVerify;
  int staffId;

  Map toJson() {
    Map map = new Map();
    map["dateFrom"] = dateFrom;
    map["dateTo"] = dateTo;
    map["bookingNo"] = bookingNo;
    map["customerNo"] = customerNo;
    map["fleetDesc"] = fleetDesc;
    map["approvalStatus"] = approvalStatus;
    map["isUserVerify"] = isUserVerify;
    map["StaffId"] = staffId;
    return map;
  }

  Getaprrovetriprecords();
}
