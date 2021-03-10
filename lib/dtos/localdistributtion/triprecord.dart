class TripRecord {
  int startMile;
  //DateTime startTime;
  String startTime;
  int endMile;
  //DateTime endTime;
  String endTime;
  int createUser;
  String routeMemo;
  String tripMemo;
  int tollFee;
  int parkingFee;
  int staffId;
  int bRId;
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
    map["BRId"] = bRId;
    map["Lat"] = lat;
    map["Lon"] = lon;
    return map;
  }

  TripRecord();
}
