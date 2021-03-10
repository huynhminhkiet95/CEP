class UpdateSimpleStatus {
  String tripNo;
  String eventDate;
  String eventType;
  String lon;
  String lat;
  String userId;
  String deliveryResult;
  String failReason;
  String remark;
  int orgItemNo;

  UpdateSimpleStatus();

  Map toJson() {
    Map map = new Map();
    map["TripNo"] = tripNo;
    map["EventDate"] = eventDate;
    map["EventType"] = eventType;
    map["Lon"] = lon;
    map["Lat"] = lat;
    map["UserId"] = userId;
    map["DeliveryResult"] = deliveryResult;
    map["FailReason"] = failReason;
    map["Remark"] = remark;
    map["OrgItemNo"] = orgItemNo;
    return map;
  }
}
