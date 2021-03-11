import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CEPmobile/config/constants.dart';
import 'package:CEPmobile/dtos/serverInfo.dart';
import 'package:CEPmobile/dtos/userInfor.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/globalRememberUser.dart';
import 'package:CEPmobile/globalServer.dart';
import 'package:CEPmobile/models/location/currentPosition.dart';

class SharePreferenceService {
  final SharedPreferences share;

  SharePreferenceService(this.share);

  Future<void> saveRememberUser(RememberUser rememberUser) async {
    globalRememberUser.setIsRemember = rememberUser.getIsRemember;
    globalRememberUser.setPassword = rememberUser.getPassword;
    globalRememberUser.setUserName = rememberUser.getUserName;

    share.setString(KeyConstants.userName, rememberUser.getUserName);
    share.setBool(KeyConstants.isRemember, rememberUser.getIsRemember);
    share.setString(KeyConstants.password, rememberUser.getPassword);
  }

  Future<void> getRememberUser() async {
    globalRememberUser.setIsRemember = share.getBool(KeyConstants.isRemember);
    globalRememberUser.setPassword =
        share.getString(KeyConstants.password.toString());
    globalRememberUser.setUserName =
        share.getString(KeyConstants.userName.toString());
  }

  Future<void> getServerInfo() async {
    globalServer.setServerAddress =
        share.getString(KeyConstants.addressServer) ?? "";
    globalServer.setServerCode =
        share.getString(KeyConstants.serverCode) ?? "PROD";
    globalServer.setServerNotification =
        share.getString(KeyConstants.nofificationServer) ?? "";
  }

  Future<void> updateServerInfo(ServerInfo serverInfo) async {
    share.setString(KeyConstants.serverCode, serverInfo.serverCode);
    share.setString(KeyConstants.addressServer, serverInfo.serverAddress);
    share.setString(
        KeyConstants.nofificationServer, serverInfo.serverNotification);
    share.setString(KeyConstants.serverInspection, serverInfo.serverInspection);
    share.setString(KeyConstants.serverHub, serverInfo.serverHub);
    share.setString(KeyConstants.serverSSO, serverInfo.serverSSO);

    globalServer.setServerAddress = serverInfo.serverAddress;
    globalServer.setServerCode = serverInfo.serverCode;
    globalServer.setServerNotification = serverInfo.serverNotification;
    globalServer.setServerInspection = serverInfo.serverInspection;
    globalServer.setServerHub = serverInfo.serverHub;
    globalServer.setServerSSO = serverInfo.serverSSO;
    globalServer.setServerApi = serverInfo.serverApi;
  }

  Future<void> saveDriverProfile(
      String driverName,
      String phoneNumber,
      String icNumber,
      String licenseNumber,
      String fleet,
      String avatar) async {
    share.setString(KeyConstants.driverName, driverName);
    share.setString(KeyConstants.phoneNumber, phoneNumber);
    share.setString(KeyConstants.icNumber, icNumber);
    share.setString(KeyConstants.licenseNumber, licenseNumber);
    share.setString(KeyConstants.fleet, fleet);
    share.setString(KeyConstants.avatar, avatar);

    globalDriverProfile.setDriverName = driverName;
    globalDriverProfile.setPhoneNumber = phoneNumber;
    globalDriverProfile.seticNumber = icNumber;
    globalDriverProfile.setlicenseNumber = licenseNumber;
    globalDriverProfile.setfleet = fleet;
    globalDriverProfile.setavatar = avatar;
  }

  Future<void> getDriverProfile() async {
    globalDriverProfile.setDriverName =
        share.getString(KeyConstants.driverName) ?? "";
    globalDriverProfile.setPhoneNumber =
        share.getString(KeyConstants.phoneNumber) ?? "";
    globalDriverProfile.seticNumber =
        share.getString(KeyConstants.icNumber) ?? "";
    globalDriverProfile.setlicenseNumber =
        share.getString(KeyConstants.licenseNumber) ?? "";
    globalDriverProfile.setfleet = share.getString(KeyConstants.fleet) ?? "";
    globalDriverProfile.setavatar = share.getString(KeyConstants.avatar) ?? "";
  }

  Future<void> updateCurrentPosition(LocationData location) async {
    share.setDouble(KeyConstants.latitude, location.latitude);
    share.setDouble(KeyConstants.longitude, location.longitude);
  }

  Future<CurrentPosition> getCurrentPosition() async {
    var currentPosition = new CurrentPosition();
    currentPosition.setLat = share.getDouble(KeyConstants.latitude);
    currentPosition.setLon = share.getDouble(KeyConstants.longitude);
    return currentPosition;
  }
}
