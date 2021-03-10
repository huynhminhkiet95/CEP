
class SaveAcceptTrip {
  String bookNo;
  int bRId;
  int createUser;
  int fleetId;
  int staffId;

  Map toJson() {
    Map map = new Map();
    map["BookNo"] = bookNo;
    map["BRId"] = bRId;
    map["CreateUser"] = createUser;
    map["FleetId"] = fleetId;
    map["StaffId"] = staffId;

    return map;
  }

  SaveAcceptTrip();
}
