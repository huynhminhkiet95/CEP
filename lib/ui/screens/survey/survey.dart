import 'package:CEPmobile/config/colors.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:ff_navigation_bar/ff_navigation_bar_item.dart';
import 'package:ff_navigation_bar/ff_navigation_bar_theme.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/CustomIcons/my_flutter_app_icons.dart';
import 'package:CEPmobile/ui/screens/survey/listofsurveymembers.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _selectedIndex = 0;
  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  List<Widget> _widgetOptions = <Widget>[
    new ListOfSurveyMembers(),
    Text(
      'Thông Tin',
      style: optionStyle,
    ),
    Text(
      'Vay Lần 1',
      style: optionStyle,
    ),
    Text(
      'Nhu Cầu Vây',
      style: optionStyle,
    ),
    Text(
      'Vay Nguồn Khác',
      style: optionStyle,
    ),
    Text(
      'Đánh Giá',
      style: optionStyle,
    ),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: ColorConstants.cepColorBackground,
        elevation: 20,
        title: const Text('Khảo Sát Vay Vốn'),
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ConvexAppBar(
          height: 60,
          items: [
            TabItem(
              icon: Icons.list,
              title: orientation == Orientation.portrait
                  ? 'Danh S...'
                  : 'Danh Sách',
            ),
            TabItem(icon: Icons.info, title: 'Thông Tin'),
            TabItem(icon: IconsCustomize.loan, title: 'Vay Lần 1'),
            TabItem(
                icon: Icons.money,
                title: orientation == Orientation.portrait
                    ? 'Nhu Cầu...'
                    : 'Nhu Cầu Vốn'),
            TabItem(
                icon: IconsCustomize.networking,
                title: orientation == Orientation.portrait
                    ? 'Vay Ng...'
                    : 'Vay Nguồn Khác'),
            TabItem(icon: IconsCustomize.survey_icon, title: 'Đánh Giá'),
          ],
          //curveSize: 100,
          //initialActiveIndex: 3,
          onTap: onItemTapped,
          activeColor: Colors.white,
          backgroundColor: ColorConstants.cepColorBackground),
    );
  }
}
