class DayTripRecord {
  int startMile;
  String startTime;
  int endMile;
  String endTime;
  int createUser;
  String routeMemo;
  String tripMemo;
  int tollFee;
  int parkingFee;
  int staffId;
  String fleetDesc;
  String lat;
  String lon;

  Map toJson() {
    Map map = new Map();
    map["StartMile"] = startMile;
    map["StartTime"] = startTime;
    map["EndMile"] = endMile;
    map["EndTime"] = endTime;
    map["CreateUser"] = createUser;
    map["RouteMemo"] = routeMemo;
    map["TripMemo"] = tripMemo;
    map["TollFee"] = tollFee;
    map["ParkingFee"] = parkingFee;
    map["StaffId"] = staffId;
    map["Fleet_Desc"] = fleetDesc;
    map["Lat"] = lat;
    map["Lon"] = lon;
    return map;
  }

  DayTripRecord();
}
