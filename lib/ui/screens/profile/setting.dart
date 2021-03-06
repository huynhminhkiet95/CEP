import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/bloc_helpers/bloc_provider.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/authentication/authentication_bloc.dart';
import 'package:CEPmobile/blocs/authentication/authentication_event.dart';
import 'package:CEPmobile/blocs/setting/setting_bloc.dart';
import 'package:CEPmobile/blocs/setting/setting_event.dart';
import 'package:CEPmobile/blocs/setting/setting_state.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/ui/components/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:settings_ui/settings_ui.dart';
import 'dart:io';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  bool isAuthenLocal = false;
  double screenWidth, screenHeight;
  bool _passwordVisible;
  TextEditingController _passwordController =
      new TextEditingController(text: "");
  AuthenticationBloc _authenticationBloc;
  PackageInfo packageInfo;
  SettingBloc settingBloc;
  Services services;
  int _isAuthenType = 0;
  final LocalAuthentication localAuth = LocalAuthentication();
  String language;
  @override
  void initState() {
    _passwordVisible = false;
    getVersionInfo();
    language = allTranslations.currentLanguage;
    _getAvailableBiometrics();
    services = Services.of(context);
    settingBloc = new SettingBloc(
        services.sharePreferenceService, services.commonService);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    settingBloc.emitEvent(LoadAuthenLocalEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.cepColorBackground,
        elevation: 20,
        title: Text(
          allTranslations.text("Setting"),
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: BlocEventStateBuilder<SettingState>(
          bloc: settingBloc,
          builder: (BuildContext context, SettingState state) {
            return StreamBuilder<bool>(
                stream: settingBloc.getIsAuthenLocal,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data != null) {
                    isAuthenLocal = snapshot.data;
                  }
                  return buildSettingsList();
                });
          }),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      darkBackgroundColor: Colors.black,
      lightBackgroundColor: Colors.white,
      sections: [
        SettingsSection(
          title: 'Chung',
          tiles: [
            SettingsTile(
              title: allTranslations.text("Language"),
              subtitle: language == 'vi' ? 'Ti???ng Vi???t' : 'English',
              leading: Icon(Icons.language),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'SourceSansPro',
                fontSize: 16,
              ),
              subtitleTextStyle: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 14,
                  color: Colors.grey),
              onTap: () {
                Navigator.pushNamed(context, 'language').then((value) {
                  setState(() {
                    language = allTranslations.currentLanguage;
                  });
                });
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'T??i kho???n',
          tiles: [
            SettingsTile(
              title: allTranslations.text("PhoneNumber"),
              leading: Icon(Icons.phone),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'SourceSansPro',
                fontSize: 16,
              ),
            ),
            SettingsTile(
              title: allTranslations.text("Email"),
              leading: Icon(Icons.email),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'SourceSansPro',
                fontSize: 16,
              ),
            ),
            SettingsTile(
              title: allTranslations.text("Logout"),
              leading: Icon(Icons.exit_to_app),
              onTap: () => _loginSubmit(),
            ),
          ],
        ),
        SettingsSection(
          title: 'B???o m???t',
          tiles: [
            SettingsTile.switchTile(
                title: allTranslations.text("FingerPrinting"),
                leading: Icon(
                  Icons.fingerprint,
                  color: Colors.red,
                ),
                onToggle: (bool value) async {
                  await _getAvailableBiometrics();
                  if (_isAuthenType == 0) {
                    showAuthenPopup();
                  } else {
                    _passwordController.text = "";
                    dialogCustomForCEP(context,
                        allTranslations.text("FingerPrinting"), _onSubmit,
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            style: TextStyle(color: Colors.blue),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              fillColor: Colors.red,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20.0)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: allTranslations.text("password"),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.lock_open,
                                  color: Colors.blue,
                                ),
                              ),
                              suffixStyle: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                        width: screenWidth * 0.7);
                  }
                },
                switchValue: isAuthenLocal),
            SettingsTile(
              title: allTranslations.text("ChangePassword"),
              leading: Icon(Icons.lock),
              onTap: () {},
            ),
            SettingsTile.switchTile(
              title: allTranslations.text("Announcement"),
              enabled: notificationsEnabled,
              leading: Icon(Icons.notifications_active),
              switchValue: true,
              onToggle: (value) {},
            ),
          ],
        ),
        CustomSection(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22, bottom: 8),
                child: Image.asset(
                  'assets/menus/icon_setting.png',
                  height: 50,
                  width: 50,
                  color: Color(0xFF777777),
                ),
              ),
              Text(
                'Version: ${packageInfo.version}(${packageInfo.buildNumber})',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onSubmit() {
    settingBloc.emitEvent(
        UpdateAuthenLocalEvent(_passwordController.text, isAuthenLocal));
  }

  void _loginSubmit() {
    _authenticationBloc.emitEvent(AuthenticationEventLogout());
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await localAuth.getAvailableBiometrics();
      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          setState(() {
            _isAuthenType = 1;
          });
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
          _isAuthenType = 2;
        }
      } else {
        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          _isAuthenType = 2;
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    // setState(() {
    //   _biometricTypes = availableBiometrics;
    // });
  }

  showAuthenPopup() async {
    var localAuth = LocalAuthentication();
    try {
      var androidStrings = AndroidAuthMessages(
          cancelButton: allTranslations.text("Cancel"),
          goToSettingsButton: allTranslations.text("Settings"),
          goToSettingsDescription: allTranslations.text("PleaseSetupTouchID"),
          fingerprintSuccess: allTranslations.text("SuccessfulAuthentication"),
          fingerprintHint: "",
          fingerprintRequiredTitle: allTranslations.text("SetupTouchID"),
          signInTitle: "Touch ID for CEP-Nh??n vi??n",
          fingerprintNotRecognized: "aaa");
      bool isAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Vui l??ng qu??t v??n tay ????? ????ng nh???p !',
          stickyAuth: true,
          androidAuthStrings: androidStrings);
      print('isAuthenticate: ' + isAuthenticate.toString());
    } on PlatformException catch (e) {
      print(e);
    }
  }

  getVersionInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}
