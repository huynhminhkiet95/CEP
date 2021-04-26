import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/ui/screens/profile/language.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
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
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Chung',
          tiles: [
            SettingsTile(
              title: 'Ngôn ngữ',
              subtitle: 'Tiếng Việt',
              leading: Icon(Icons.language),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LanguagesScreen(),
                ));
              },
            ),
            SettingsTile(
              title: 'Môi trường',
              subtitle: 'Production',
              leading: Icon(Icons.cloud_queue),
            ),
          ],
        ),
        SettingsSection(
          title: 'Tài khoản',
          tiles: [
            SettingsTile(title: 'Số điện thoại', leading: Icon(Icons.phone)),
            SettingsTile(title: 'Email', leading: Icon(Icons.email)),
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
                onToggle: (bool value) {},
                switchValue: false),
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
}
