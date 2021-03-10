import 'package:CEPmobile/dtos/dtobase.dart';

class DataLogin extends BaseDto {
  String username;
  String password;
  String granttype;
  String clientid;

  DataLogin({this.username, this.password, this.granttype, this.clientid});

  @override
  Map toJson() {
    Map map = new Map();
    map["username"] = username;
    map["password"] = password;
    map["grant_type"] = granttype;
    map["client_id"] = clientid;
    return map;
  }
}
