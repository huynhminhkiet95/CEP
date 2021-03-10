class UploadDocumentEntry {
  String fileName;
  String docRefType;
  String refNoType;
  String refNoValue;
  String userId;
  String stringData;


  Map toJson() {
    Map map = new Map();
    map["FileName"] = fileName;
    map["DocRefType"] = docRefType;
    map["RefNoType"] = refNoType;
    map["RefNoValue"] = refNoValue;
    map["UserId"] = userId;
    map["StringData"] = stringData;

    return map;
  }

  UploadDocumentEntry();
}
