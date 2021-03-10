class WorkOrderStatus {
  int wOTaskId;
  String eventDate;
  String eventType;
  String lat;
  String lon;
  String userId;
  String cNTRNo;
  String sealNo;

  Map toJson() {
    Map map = new Map();
    map["WOTaskId"] = wOTaskId;
    map["EventDate"] = eventDate;
    map["EventType"] = eventType;
    map["Lat"] = lat;
    map["Lon"] = lon;
    map["UserId"] = userId;
    map["CNTRNo"] = cNTRNo;
     map["SealNo"] = sealNo;
    return map;
  }

  WorkOrderStatus();
}
