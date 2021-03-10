class HaulageTodoSearch {
  String dateFrom;
  String dateTo;
  String equipmentCode;
  String isOnlyPending;



  Map toJson() {
    Map map = new Map();
    map["DateFrom"] = dateFrom;
    map["DateTo"] = dateTo;
    map["EquipmentCode"] = equipmentCode;
    map["IsOnlyPending"] = isOnlyPending;
    return map;
  }

  HaulageTodoSearch();
}