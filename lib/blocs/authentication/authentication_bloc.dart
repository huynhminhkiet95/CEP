import 'dart:convert';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/bloc_helpers/bloc_sinletion.dart';
import 'package:CEPmobile/blocs/authentication/authentication_event.dart';
import 'package:CEPmobile/blocs/authentication/authentication_state.dart';
import 'package:CEPmobile/dtos/datalogin.dart';
import 'package:CEPmobile/dtos/serverInfo.dart';
import 'package:CEPmobile/dtos/userInfor.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/globalRememberUser.dart';
import 'package:CEPmobile/globalServer.dart';
import 'package:CEPmobile/models/comon/PageMenuPermission.dart';
import 'package:CEPmobile/models/users/ValidateUserIdPwdJsonResult.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:CEPmobile/ui/screens/Home/home.dart';

class AuthenticationBloc
    extends BlocEventStateBase<AuthenticationEvent, AuthenticationState> {
  final CommonService _commonService;
  final SharePreferenceService _sharePreferenceService;

  AuthenticationBloc(this._commonService, this._sharePreferenceService)
      : super(
            initialState: AuthenticationState.defaultAuthenticationState(
                globalRememberUser.getIsRemember ?? false,
                globalRememberUser.getUserName,
                globalRememberUser.getPassword,
                globalServer.getServerCode));

  @override
  Stream<AuthenticationState> eventHandler(
      AuthenticationEvent event, AuthenticationState currentState) async* {
    if (event is AuthenticationEventLogin) {
      yield AuthenticationState.authenticating(currentState);
      var server = new ServerInfo();
      switch (event.serverCode) {
        case "DEV":
          server.serverAddress = "https://dev.igls.vn:9110/";
          server.serverApi = "https://dev.igls.vn:9101/";
          server.serverCode = event.serverCode;
          server.serverNotification = "https://dev.igls.vn:8091/";
          server.serverInspection = "https://dev.igls.vn:9102/";
          server.serverHub = "http://192.168.70.132:8079/";
          // server.serverSSO = "https://mpi.mplogistics.vn:8187/";
          server.serverSSO = "https://dev.igls.vn:9110/";
          //"https://dev.igls.vn:9110/";
          break;
        case "PROD":
          server.serverAddress = "https://fbmp.enterprise.vn:9110/";
          server.serverApi = "https://fbmp.enterprise.vn:9110/";
          server.serverCode = event.serverCode;
          server.serverNotification = "https://fbmp.enterprise.vn:9101/";
          server.serverInspection = "https://fmbp.enterprise.vn/";
          server.serverHub = "https://pro.igls.vn:8182/";
          server.serverSSO = "https://fbmp.enterprise.vn:9110/";
          break;
      }

      var dataToken = new DataLogin(
        username: event.userName,
        password: event.password,
        granttype: "password",
        clientid: 'MB_ENT',
      );
      this._sharePreferenceService.updateServerInfo(server);
      var token = await this
          ._commonService
          .getToken(dataToken)
          .then((response) => response);
      if (token.statusCode == 200) {
        var jsonBodyToken = json.decode(token.body);
        globalUser.settoken = jsonBodyToken["access_token"];
        var employeeId = jsonBodyToken["as:employee_id"];
        var systemid = jsonBodyToken["as:system_id"];
        globalUser.setId = int.parse(employeeId);

        var result = await this
            ._commonService
            .getEmployeePrivate(employeeId, systemid)
            .then((response) => response);
        if (result == null) {
          yield AuthenticationState.failure(currentState);
        } else if (result.statusCode == 200) {
          if (result.contentLength > 0 && result.body.isNotEmpty) {
            var jsonBody = json.decode(result.body);
            if (jsonBody["payload"]["userDetail"] != null) {
              globalRememberUser.setIsRemember = event.isRemember;
              globalRememberUser.setUserName = event.userName;
              globalRememberUser.setPassword = event.password;
              globalServer.setServerCode = event.serverCode;
              globalServer.setServerApi = server.serverApi;

              getStaffInfo();

              UserInfoPwdJsonResult userIdPwdJsonResult;
              userIdPwdJsonResult = UserInfoPwdJsonResult.fromJson(jsonBody);

              if (userIdPwdJsonResult != null) {
                //get list menu
                final response = await this._commonService.getMenuPermission(
                    event.userName,
                    "MB_ENT",
                    userIdPwdJsonResult.userInfo.subsidiaryId);

                if (response != null &&
                    response.statusCode == 200 &&
                    response.body.isNotEmpty) {
                  var pageMenuJson = json.decode(response.body);
                  if (pageMenuJson.length > 0) {
                    var menuChildJson = pageMenuJson["payload"]
                        .cast<Map<String, dynamic>>() as List;
                    var menus = new List<PageMenuPermission>();
                    if (menuChildJson.length > 0) {
                      menus = menuChildJson
                          .map<PageMenuPermission>((jsonItem) =>
                              PageMenuPermission.fromJson(jsonItem))
                          .toList();
                    }
                    pages.clear();
                    pages.addAll(menus);
                  }

                  yield AuthenticationState.authenticated(
                      event.isRemember,
                      event.userName,
                      event.password,
                      currentState.serverCode,
                      userIdPwdJsonResult);

                  server.serverHub =
                      userIdPwdJsonResult.systemInfo.notificationUrl.trim();
                  server.serverInspection =
                      userIdPwdJsonResult.systemInfo.inspectionUrl.trim();
                  this._sharePreferenceService.updateServerInfo(server);

                  globalUser.setSystemId =
                      userIdPwdJsonResult.systemInfo.systemId;
                  globalBloc.addUserInfo(userIdPwdJsonResult);
                  globalUser.setUserName =
                      userIdPwdJsonResult.userInfo.employeeName;
                  globalUser.setuserId = event.userName;
                  globalUser.setSubsidiaryId =
                      userIdPwdJsonResult.userInfo.subsidiaryId;
                  //globalUser.setStaffId = userIdPwdJsonResult.staffInfo.staffId;
                  if (userIdPwdJsonResult.userInfo.employeeName.isNotEmpty) {
                    globalDriverProfile.setDriverName =
                        userIdPwdJsonResult.userInfo.employeeName;
                  }
                  //if (userIdPwdJsonResult.staffInfo.fleetdesc.isNotEmpty) {
                  // if (globalDriverProfile.getfleet !=
                  //     validateUserIdPwdJsonResult.staffInfo.fleetdesc) {
                  //   if (globalUser.getNotification == null ||
                  //       !globalUser.getNotification) {
                  //     if (socket != null &&
                  //         sessionId.isNotEmpty &&
                  //         tokenfcm.isNotEmpty) {
                  //       var strJson =
                  //           '{"SessionId": "$sessionId", "FleetId": "${validateUserIdPwdJsonResult.staffInfo.fleetdesc}", "Token":"$tokenfcm"}';
                  //       socket.emit(SocketIOEvent.update_fleetId, [strJson]);
                  //     }
                  //   }
                  // }
                  //   if (userIdPwdJsonResult.staffInfo.fleetdesc != null &&
                  //       userIdPwdJsonResult.staffInfo.fleetdesc.isNotEmpty) {
                  //     globalDriverProfile.setfleet =
                  //         userIdPwdJsonResult.staffInfo.fleetdesc;
                  //   }
                  // }
                  if (userIdPwdJsonResult.userInfo.mobile.isNotEmpty) {
                    globalDriverProfile.setPhoneNumber =
                        userIdPwdJsonResult.userInfo.mobile;
                  }

                  var user = new RememberUser();
                  if (event.isRemember == true) {
                    user.setIsRemember = event.isRemember;
                    user.setPassword = event.password;
                    user.setUserName = event.userName;
                  }

                  this._sharePreferenceService.saveRememberUser(user);
                }
              } else {
                yield AuthenticationState.userIsNotExits(currentState, true);
              }
            } else {
              yield AuthenticationState.userIsNotExits(currentState, true);
            }
          } else {
            yield AuthenticationState.userIsNotExits(currentState, true);
          }
        } else {
          yield AuthenticationState.failure(currentState);
        }
      } else {
        yield AuthenticationState.userIsNotExits(currentState, true);
      }
    }

    if (event is AuthenticationEventLogout) {
      if (currentState.isRemember) {
        yield AuthenticationState.notAuthenticated(
            currentState.serverCode,
            currentState.userName,
            currentState.password,
            currentState.isRemember);
      } else {
        yield AuthenticationState.notAuthenticated(
            currentState.serverCode, "", "", false);
      }
    }
  }

  Future getStaffInfo() async {
    var getStaff = await _commonService.getStaff(globalUser.getId);
    if (getStaff != null && getStaff.statusCode == 200) {
      var dataBody = json.decode(getStaff.body);
      if (dataBody["payload"] != null) {
        var staffInfo = StaffInfo.fromJson(dataBody);
        globalUser.setStaffId = staffInfo.staffId;
        globalDriverProfile.setfleet = staffInfo.fleetdesc;
      }
    }
  }
}
