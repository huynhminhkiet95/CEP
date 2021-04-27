import 'package:CEPmobile/GlobalTranslations.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/blocs/setting/setting_bloc.dart';
import 'package:CEPmobile/blocs/setting/setting_event.dart';
import 'package:CEPmobile/blocs/setting/setting_state.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/ui/components/CustomDialog.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';
import 'package:CEPmobile/ui/screens/profile/language.dart';
import 'package:flutter/material.dart';
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

  SettingBloc settingBloc;
  Services services;
  int _isAuthenType = 0;
  final LocalAuthentication localAuth = LocalAuthentication();
  @override
  void initState() {
    _passwordVisible = false;
    _getAvailableBiometrics();
    services = Services.of(context);
    settingBloc = new SettingBloc(
        services.sharePreferenceService, services.commonService);
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
          'Settings',
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
              title: 'Ngôn ngữ',
              subtitle: 'Tiếng Việt',
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LanguagesScreen(),
                ));
              },
            ),
          
          ],
        ),
        SettingsSection(
          title: 'Tài khoản',
          tiles: [
            SettingsTile(
              title: 'Số điện thoại',
              leading: Icon(Icons.phone),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'SourceSansPro',
                fontSize: 16,
              ),
            ),
            SettingsTile(
              title: 'Email',
              leading: Icon(Icons.email),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'SourceSansPro',
                fontSize: 16,
              ),
            ),
            SettingsTile(title: 'Đăng xuất', leading: Icon(Icons.exit_to_app)),
          ],
        ),
        SettingsSection(
          title: 'Bảo mật',
          tiles: [
            SettingsTile.switchTile(
                title: 'Xác thực vân tay',
                leading: Icon(
                  Icons.fingerprint,
                  color: Colors.red,
                ),
                onToggle: (bool value) async{
                  await _getAvailableBiometrics();
                  if (_isAuthenType == 0) {
                    showAuthenPopup();
                  } else {
                    _passwordController.text = "";
                    dialogCustomForCEP(context, "Xác thực vân tay", _onSubmit,
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
              title: 'Thay đổi mật khẩu',
              leading: Icon(Icons.lock),
              onTap: () {},
            ),
            SettingsTile.switchTile(
              title: 'Thông báo',
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
                'Version: 1.0.0',
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
      const androidStrings = const AndroidAuthMessages(
          cancelButton: "Hủy",
          goToSettingsButton: "Cài Đặt",
          goToSettingsDescription: 'Vui lòng thiết lập Touch ID của bạn !',
          fingerprintSuccess: 'Xác thực thành công.',
          fingerprintHint: "",
          fingerprintRequiredTitle: "Thiết lập Touch-ID",
          signInTitle: "Touch ID for CEP-Nhân viên",
          fingerprintNotRecognized: "aaa");
      bool isAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Vui lòng quét vân tay để đăng nhập !',
          stickyAuth: true,
          androidAuthStrings: androidStrings);
      print('isAuthenticate: ' + isAuthenticate.toString());
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
