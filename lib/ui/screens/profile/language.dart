import 'package:CEPmobile/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.cepColorBackground,
        elevation: 20,
        title: Text(
          'Ngôn ngữ',
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
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: "Tiếng Việt",
              trailing: trailingWidget(0),
              onTap: () {
                changeLanguage(0);
              },
            ),

            SettingsTile(
              title: "English",
              trailing: trailingWidget(1),
              onTap: () {
                changeLanguage(1);
              },
            ),

            SettingsTile(
              title: "Spanish",
              trailing: trailingWidget(2),
               onTap: ()  {
                changeLanguage(2);
              },
            ),
            SettingsTile(
              title: "Chinese",
              trailing: trailingWidget(3),
               onTap: ()  {
                changeLanguage(3);
              },
            ),
            SettingsTile(
              title: "German",
              trailing: trailingWidget(4),
               onTap: () {
                changeLanguage(4);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
  }
}
