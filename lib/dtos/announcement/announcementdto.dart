// class GetAnnouncements {
//   String userId;
  


//   Map toJson() {
//     Map map = new Map();
//     map["UserId"] = userId;
//     map["DateTo"] = dateTo;
//     map["AnnType"] = annType;
//     map["Subject"] = subject;

//     return map;
//   }

//   GetAnnouncements();
// }

class SaveAnnouncementEndorse {
  int annId ;
  int agreedUser ;
  String comment;

  Map toJson() {
    Map map = new Map();
    map["AnnId"] = annId;
    map["AgreedUser"] = agreedUser;
    map["Comment"] = comment;

    return map;
  }

   
}
