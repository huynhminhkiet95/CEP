import 'dart:convert';
import 'dart:io';
import 'package:CEPmobile/config/version.dart';
import 'package:CEPmobile/dtos/serverInfo.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/authentication/authentication_bloc.dart';
import 'package:CEPmobile/blocs/authentication/authentication_event.dart';
import 'package:CEPmobile/blocs/authentication/authentication_state.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../globalRememberUser.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:launch_review/launch_review.dart';

String userName = '';
String password = '';
String _server = 'DEV';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  //AnimationController _loginButtonController;
  TextEditingController _userNameController =
      new TextEditingController(text: "");
  TextEditingController _passwordController =
      new TextEditingController(text: "");
  //String _server;

  bool _isRemember = false;
  bool _isFaceID = false;
  final _formKey = GlobalKey<FormState>();
  String language = allTranslations.currentLanguage;
  List _servers = ["DEV", "PROD"];
  List<DropdownMenuItem<String>> _dropDownMenuItemsServer;
  AuthenticationBloc authenticationBloc;
  var animationStatus = 0;
  Services services;
  final LocalAuthentication localAuth = LocalAuthentication();
  bool _cancheckBiometric = false;
  String _authorizedOrNot = 'Not Auth';
  List<BiometricType> _biometricTypes = List<BiometricType>();

  void _updateRemember(bool value) => {
        setState(() {
          _isRemember = value;
        })
      };

  @override
  void initState() {
    services = Services.of(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _dropDownMenuItemsServer = buildAndGetDropDownMenuItems(_servers);
    if (globalRememberUser.getIsRemember != null &&
        globalRememberUser.getIsRemember) {
      if (password.isEmpty && userName.isEmpty) {
        setState(() {
          _userNameController.text = globalRememberUser.getUserName?.toString();
          //_passwordController.text = globalRememberUser.getPassword?.toString();
        });
      } else {
        setState(() {
          _userNameController.text = userName;
          _passwordController.text = password;
        });
      }
      setState(() {
        _isRemember = globalRememberUser.getIsRemember ?? false;
        _server = "PROD";
      });
    } else {
      _server = "PROD";
    }
    checkBiometric();
    checknewVersion();
    super.initState();
  }

  Future checknewVersion() async {
    var isnewVersion = await checkVersion();
    if (!isnewVersion) {
      _showDialog();
    }
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List menus) {
    List<DropdownMenuItem<String>> items = new List();
    for (String item in menus) {
      items.add(new DropdownMenuItem(value: item, child: new Text(item)));
    }
    return items;
  }

  void changedDropDownItem(String selectedvalue) {
    setState(() {
      _server = selectedvalue;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() {
    var showDialog2 = showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            title: new Text('Are you sure?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => {exit(0)},
                child: new Text('Yes'),
              ),
            ],
          );
        });
    return showDialog2 ?? false;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo/bg.png"),
                    fit: BoxFit.fill,
                  ),
                  color: Colors.white),
              child: BlocEventStateBuilder<AuthenticationState>(
                  bloc: authenticationBloc,
                  builder: (BuildContext context, AuthenticationState state) {
                    return ModalProgressHUDCustomize(
                        inAsyncCall: state.isAuthenticating,
                        child: new Container(
                            child: new ListView(
                          padding: const EdgeInsets.all(0.0),
                          children: <Widget>[
                            new Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: <Widget>[
                                Card(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.3,
                                      left: 20,
                                      right: 20),
                                  color: Colors.white54,
                                  child: new Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      // new Container(
                                      //   margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                                      //   // width: double.infinity,
                                      //   // height: double.infinity,
                                      //   //child: new Tick(image: tick),
                                      // ),
                                      new Container(
                                        child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            new Form(
                                                key: this._formKey,
                                                child: new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    new Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 20,
                                                          right: 20),
                                                      color: Colors.white,
                                                      child: new TextFormField(
                                                          controller:
                                                              _userNameController,
                                                          validator: (value) {
                                                            if (value.isEmpty &&
                                                                value.length <
                                                                    3) {
                                                              return allTranslations
                                                                  .text(
                                                                      "UserNameValidation");
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0.0)),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        20.0,
                                                                        15.0,
                                                                        20.0,
                                                                        15.0),
                                                            hintText:
                                                                allTranslations
                                                                    .text(
                                                                        "user_name"),
                                                            prefixIcon: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .account_circle,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    new Container(
                                                      margin: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      color: Colors.white,
                                                      child: new TextFormField(
                                                        controller:
                                                            _passwordController,
                                                        validator: (value) {
                                                          if (value.isEmpty &&
                                                              value.length <
                                                                  3) {
                                                            return allTranslations
                                                                .text(
                                                                    "PasswordValidation");
                                                          }
                                                          return null;
                                                        },
                                                        obscureText: true,
                                                        decoration:
                                                            InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0)),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      20.0,
                                                                      15.0,
                                                                      20.0,
                                                                      15.0),
                                                          hintText:
                                                              allTranslations
                                                                  .text(
                                                                      "password"),
                                                          prefixIcon: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0.0),
                                                              child: Icon(
                                                                Icons.vpn_key,
                                                                color:
                                                                    Colors.grey,
                                                              )),
                                                          suffixIcon:
                                                              !_cancheckBiometric
                                                                  ? null
                                                                  : IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        auThenticate();
                                                                      },
                                                                      icon: !_isFaceID
                                                                          ? Icon(
                                                                              Icons.fingerprint,
                                                                              color: Colors.greenAccent,
                                                                            )
                                                                          : Image.asset('assets/images/face_id.png', width: 25, height: 25, color: Colors.greenAccent),
                                                                      //     new Container(
                                                                      //   padding: EdgeInsets.symmetric(
                                                                      //       vertical:
                                                                      //           2),
                                                                      //   child: _isFaceID
                                                                      //       ? Image.asset(
                                                                      //           'assets/images/face_id.png',
                                                                      //           width:
                                                                      //               15,
                                                                      //           height:
                                                                      //               15)
                                                                      //       : Image.asset(
                                                                      //           'assets/images/touch-id1.png',
                                                                      //           width: 15,
                                                                      //           height: 15),
                                                                      // )
                                                                    ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                      new Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Switch(
                                                value: _isRemember,
                                                onChanged: _updateRemember,
                                                activeColor: Colors.green),
                                            new Text(
                                              allTranslations
                                                  .text("Rememberme"),
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            )
                                          ],
                                        ),
                                      ),
                                      new InkWell(
                                          child: new Container(
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 20),
                                              width: double.infinity,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: Color(ColorConstants
                                                    .getColorHexFromStr(
                                                        ColorConstants
                                                            .backgroud)),
                                                // gradient:
                                                //     LinearGradient(colors: [
                                                //   //Color(0xFF17ead9),
                                                //   //Color(0xFF6078ea)
                                                //   Color(ColorConstants
                                                //       .getColorHexFromStr(
                                                //           ColorConstants
                                                //               .backgroud))
                                                // ]),
                                                // borderRadius:
                                                //     BorderRadius.circular(6.0),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //       color: Color(ColorConstants
                                                //               .getColorHexFromStr(
                                                //                   ColorConstants
                                                //                       .backgroud))
                                                //           .withOpacity(.4),
                                                //       offset: Offset(0.0, 8.0),
                                                //       blurRadius: 8.0)
                                                // ]
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () async {
                                                    var _checkVersion =
                                                        await checkVersion();
                                                    if (!_checkVersion) {
                                                      return _showDialog();
                                                    }
                                                    if (this
                                                        ._formKey
                                                        .currentState
                                                        .validate()) {
                                                      this
                                                          ._formKey
                                                          .currentState
                                                          .save();
                                                      userName =
                                                          _userNameController
                                                              .text
                                                              .toString();
                                                      password =
                                                          _passwordController
                                                              .text
                                                              .toString();
                                                      authenticationBloc.emitEvent(
                                                          AuthenticationEventLogin(
                                                              userName:
                                                                  _userNameController
                                                                      .text
                                                                      .toString(),
                                                              password:
                                                                  _passwordController
                                                                      .text
                                                                      .toString(),
                                                              serverCode:
                                                                  _server,
                                                              isRemember:
                                                                  _isRemember));
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      allTranslations
                                                          .text('sign_in'),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          letterSpacing: 1.0),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                    ],
                                  ),
                                ),

                                new Container(
                                  //height: 30,
                                  //width: 300,
                                  //margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 6, bottom: 50),
                                  child: Center(
                                    child: (state.userIsNotExit ||
                                            state.hasFailed)
                                        ? new Text(
                                            getError(state),
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : new Container(),
                                  ),
                                )
                                //: new Container(),
                              ],
                            ),
                          ],
                        )));
                  })),
          floatingActionButton: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.transparent,
              child: language == 'en'
                  ? new Image.asset('assets/images/united-kingdom.png',
                      width: 30, height: 30)
                  : new Image.asset('assets/images/vietnam.png',
                      width: 30, height: 30),
              onPressed: () => setState(() {
                    language = language == 'en' ? 'vi' : 'en';
                    allTranslations.setNewLanguage(language, true);
                  })),
        )));
  }

  String getError(AuthenticationState state) {
    if (state.userIsNotExit) {
      return allTranslations.text("UserIsNotExist");
    } else if (state.hasFailed) {
      return allTranslations.text("NoConnect");
    }
    return allTranslations.text("NoConnect");
  }

  Future auThenticate() async {
    if (globalRememberUser.getPassword.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text("Automaticlogin"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }
    bool isAuthenticate = false;
    try {
      isAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: _isFaceID
              ? allTranslations.text("Usefaceid")
              : allTranslations.text("Usetouchid"),
          useErrorDialogs: true,
          //iOSAuthStrings: iosStrings,
          stickyAuth: true);
      if (isAuthenticate) {
        this._formKey.currentState.save();
        authenticationBloc.emitEvent(AuthenticationEventLogin(
            userName: _userNameController.text.toString(),
            password: globalRememberUser.getPassword,
            serverCode: _server,
            isRemember: _isRemember));
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        Fluttertoast.showToast(
            msg: allTranslations.text("TouchIdOff"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == "auth_in_progress") {
        Fluttertoast.showToast(
            msg: allTranslations.text("TouchIdnotAvailable"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    if (!mounted) return;

    setState(() {
      if (isAuthenticate) {
        _authorizedOrNot = "Authoried";
      } else {
        _authorizedOrNot = "Not Authoried";
      }
    });
  }

  Future<void> checkBiometric() async {
    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (!mounted) return;
      setState(() {
        _cancheckBiometric = canCheckBiometrics;
      });

      if (canCheckBiometrics) {
        _getAvailableBiometrics();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await localAuth.getAvailableBiometrics();
      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          setState(() {
            _isFaceID = true;
          });
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
          _isFaceID = false;
        }
      } else {
        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          _isFaceID = false;
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _biometricTypes = availableBiometrics;
    });
  }

  static const iosStrings = const IOSAuthMessages(
      cancelButton: 'cancel',
      goToSettingsButton: 'settings',
      goToSettingsDescription: 'Please set up your Touch ID',
      lockOut: 'Please reenable your Touch ID');

  Future<bool> checkVersion() async {
    var server = new ServerInfo();
    switch (_server) {
      case "DEV":
        server.serverAddress = "https://dev.igls.vn:9110/";
        server.serverApi = "https://dev.igls.vn:9101/";
        server.serverCode = _server;
        server.serverNotification = "https://dev.igls.vn:8091/";
        server.serverInspection = "https://dev.igls.vn:9102/";
        server.serverHub = "http://192.168.70.132:8079/";
        break;
      case "PROD":
        server.serverAddress = "https://fbmp.enterprise.vn:9110/";
        server.serverApi = "https://fbmp.enterprise.vn:9110/";
        server.serverCode = _server;
        server.serverNotification = "https://fbmp.enterprise.vn:9101/";
        server.serverInspection = "https://fmbp.enterprise.vn/";
        server.serverHub = "https://pro.igls.vn:8182/";
        break;
    }
    services.sharePreferenceService.updateServerInfo(server);
    var response = await services.commonService.getlastedversion();
    if (response != null &&
        response.statusCode == 200 &&
        response.body.isNotEmpty) {
      var dataJson = json.decode(response.body);
      if (dataJson['payload'].isNotEmpty) {
        var newVersion = dataJson['payload']['version'].toString();
        int value = int.parse(newVersion.substring(6, newVersion.length));
        if (VersionContanst.value < value) {
          return false;
        } else {
          return true;
        }
      }
    }
    return true;
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Update"),
          content: new Text(allTranslations.text("UpdateSystem")),
          actions: <Widget>[
            new FlatButton(
              child: new Text(allTranslations.text("OK")),
              onPressed: () {
                Navigator.of(context).pop();
                goUpdateApp();
              },
            ),
            // new FlatButton(
            //   child: new Text(allTranslations.text("Cancel")),
            //   onPressed: () {
            //     exit(0);
            //   },
            // ),
          ],
        );
      },
    );
  }

  void goUpdateApp() async {
    LaunchReview.launch(
        androidAppId: 'com.mpl.CEPmobile', iOSAppId: '1477031564');
  }
}
