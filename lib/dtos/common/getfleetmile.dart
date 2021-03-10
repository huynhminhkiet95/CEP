class GetFleetMile {
  String lastestMile;
  String lastRead;


  Map toJson() {
    Map map = new Map();
    map["LastestMile"] = lastestMile;
    map["LastRead"] = lastRead;

    return map;
  }

  GetFleetMile();
}
