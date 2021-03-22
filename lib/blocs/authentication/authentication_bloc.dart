import 'dart:async';
import 'dart:convert';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/bloc_helpers/bloc_event_state.dart';
import 'package:CEPmobile/bloc_helpers/bloc_sinletion.dart';
import 'package:CEPmobile/blocs/authentication/authentication_event.dart';
import 'package:CEPmobile/blocs/authentication/authentication_state.dart';
import 'package:CEPmobile/config/status_code.dart';
import 'package:CEPmobile/dtos/datalogin.dart';
import 'package:CEPmobile/dtos/serverInfo.dart';
import 'package:CEPmobile/globalDriverProfile.dart';
import 'package:CEPmobile/globalRememberUser.dart';
import 'package:CEPmobile/globalServer.dart';
import 'package:CEPmobile/models/users/ValidateUserIdPwdJsonResult.dart';
import 'package:CEPmobile/models/users/user_info.dart';
import 'package:CEPmobile/models/users/user_role.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

      /// khi khong co mang//

      // UserInfoPwdJsonResult userIdPwdJsonResult;
      // yield AuthenticationState.authenticated(
      //                   event.isRemember,
      //                   event.userName,
      //                   event.password,
      //                   currentState.serverCode,
      //                   userIdPwdJsonResult);
      ///

      // the network is ready to test
      var server = new ServerInfo();
      switch (event.serverCode) {
        case "DEV":
          server.serverAddress = "http://10.10.0.36:8889/";
          server.serverApi = "http://10.10.0.36:8889/";
          server.serverCode = event.serverCode;
          server.serverNotification = "http://10.10.0.36:8889/";
          break;
        case "PROD":
          server.serverAddress = "http://10.10.0.36:8889/";
          server.serverApi = "http://10.10.0.36:8889/";
          server.serverCode = event.serverCode;
          server.serverNotification = "http://10.10.0.36:8889/";
          break;
      }

      var dataToken = new DataLogin(
        userName: event.userName,
        password: event.password,
      );
      this._sharePreferenceService.updateServerInfo(server);
      var token = await this
          ._commonService
          .getToken(dataToken)
          .then((response) => response);
      if (token != null || token.body.isEmpty != true) {
        if (token.statusCode == StatusCodeConstants.OK) {
          var jsonBodyToken = json.decode(token.body);
          if (jsonBodyToken["isSuccessed"] == true) {
            if (jsonBodyToken["token"] != null) {
              globalUser.settoken = jsonBodyToken["token"];
              
              List responses = await Future.wait(
                  [getUserInfo(event.userName),getUserRoles(event.userName)]);
              if (responses != null &&
                  (responses[0] is UserInfo || responses[0] != null) &&
                  (responses[1] is UserRole || responses[1] != null)) {
                globalUser.setUserInfo = responses[0];
                globalUser.setUserRoles = responses[1];
                yield AuthenticationState.authenticated(event.isRemember,
                    event.userName, event.password, currentState.serverCode);
              }
            }
          } else {
            yield AuthenticationState.failedByUser(currentState);
            Fluttertoast.showToast(
              msg: allTranslations.text("UserIsNotExist"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red[300].withOpacity(0.7),
              textColor: Colors.white,
            );
          }
        } else if (token.statusCode == StatusCodeConstants.BAD_REQUEST) {
          yield AuthenticationState.failedByUser(currentState);
          Fluttertoast.showToast(
            msg: allTranslations.text("ServerNotFound"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // also possible "TOP" and "CENTER"
            backgroundColor: Colors.red[300].withOpacity(0.7),
            textColor: Colors.white,
          );
        }
      }
    }

    if (event is AuthenticationEventLogout) {
      globalUser.settoken = "";
      if (currentState.isRemember) {
        yield AuthenticationState.notAuthenticated(currentState.userName,
            currentState.password, currentState.isRemember);
      } else {
        yield AuthenticationState.notAuthenticated("", "", false);
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

  Future<UserInfo> getUserInfo(String userName) async {
    UserInfo userInfoModel = null;
    try {
      var userInfo = await this
          ._commonService
          .getGetUser(userName)
          .then((response) => response);
      if (userInfo.statusCode == StatusCodeConstants.OK) {
        var jsonBodyUserInfo = json.decode(userInfo.body);
        if (jsonBodyUserInfo["isSuccessed"]) {
          var dataUserInfo = UserInfo.fromJson(jsonBodyUserInfo["data"] == null || jsonBodyUserInfo["data"].isEmpty ? null : jsonBodyUserInfo["data"].first);
          userInfoModel = dataUserInfo;
        }
      }
    } catch (e) {
      userInfoModel = null;
    }
    return userInfoModel;
  }

  Future<UserRole> getUserRoles(String userName) async {
    UserRole userRolesModel = null;
    try {
      var userRoles = await this
          ._commonService
          .getUserRoles(userName)
          .then((response) => response);
      if (userRoles.statusCode == StatusCodeConstants.OK) {
        var jsonBodyUserRoles = json.decode(userRoles.body);
        if (jsonBodyUserRoles["isSuccessed"]) {
          var dataUserRoles = UserRole.fromJson(jsonBodyUserRoles["data"] == null || jsonBodyUserRoles["data"].isEmpty ? null : jsonBodyUserRoles["data"].first);
          userRolesModel = dataUserRoles;
        }
      }
    } catch (e) {
      userRolesModel = null;
    }
    return userRolesModel;
  }
}
