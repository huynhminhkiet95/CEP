class GetTodoBookings {
  String equipment;
  String todoDate;


  Map toJson() {
    Map map = new Map();
    map["Equipment"] = equipment;
    map["TodoDate"] = todoDate;

    return map;
  }

  GetTodoBookings();
}
