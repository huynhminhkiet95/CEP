
class SavePickUpTrip {
  int bRId;
  String eventDate;
  String eventType;
  String placeDesc;
  String remark;
  String lat;
  String lon;
  int userId;

  Map toJson() {
    Map map = new Map();
    
    map["BRId"] = bRId;
    map["EventDate"] = eventDate;
    map["EventType"] = eventType;
    map["PlaceDesc"] = placeDesc;
    map["Remark"] = remark;
    map["Lat"] = lat;
    map["Lon"] = lon;
    map["UserId"] = userId;
    return map;
  }

  SavePickUpTrip();
}
