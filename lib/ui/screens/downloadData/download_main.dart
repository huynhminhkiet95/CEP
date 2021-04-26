import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/global_variables/global_download.dart';
import 'package:CEPmobile/ui/screens/downloadData/download_survey.dart';
import 'package:CEPmobile/ui/screens/downloadData/download_dept.dart';
import 'package:CEPmobile/ui/screens/downloadData/download_saving.dart';
import 'package:CEPmobile/ui/screens/downloadData/download_community_development.dart';
import 'package:CEPmobile/ui/screens/downloadData/download_metadata.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/CustomIcons/my_flutter_app_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DownloadScreen extends StatefulWidget {
  final int selectedIndex;
  const DownloadScreen({Key key, this.selectedIndex}) : super(key: key);
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  int _selectedIndex = 0;
  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  bool isStatusDownLoad = false;
  List<Widget> _widgetOptions = <Widget>[
    new DownloadSurvey(),
    new DownloadDept(),
    new DownloadSaving(),
    new DownloadCommunityDevelopment(),
    new DownloadMetaData(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex;
      Fluttertoast.showToast(
        msg: "Vui lòng tải dữ liệu cho Combobox !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[300].withOpacity(0.7),
        textColor: Colors.black,
      );
    }
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
          onPressed: () {
            Navigator.pop(context, GlobalDownload.isSubmitDownload);
            //bool a = GlobalDownload.isSubmitDownload;
          },
        ),
        backgroundColor: ColorConstants.cepColorBackground,
        elevation: 20,
        title:  Text('Tải Xuống', textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dx > sensitivity) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
          height: 60,
          items: [
            TabItem(
              icon: IconsCustomize.survey_icon,
              title:
                  orientation == Orientation.portrait ? 'Khảo Sát' : 'Khảo Sát',
            ),
            TabItem(icon: IconsCustomize.thu_no, title: 'Thu Nợ'),
            TabItem(
                icon: IconsCustomize.tu_van,
                title: orientation == Orientation.portrait
                    ? 'Tư Vấn T...'
                    : 'Tư Vấn Tiết Kiệm'),
            TabItem(
                icon: IconsCustomize.phattriencongdong,
                title: orientation == Orientation.portrait ? 'PTCĐ' : 'PTCĐ'),
            TabItem(
                icon: Icons.list,
                title: orientation == Orientation.portrait
                    ? 'Danh Sách...'
                    : 'Danh Sách Chọn'),
          ],
          //curveSize: 100,
          initialActiveIndex: _selectedIndex,
          onTap: onItemTapped,
          activeColor: Colors.white,
          backgroundColor: ColorConstants.cepColorBackground),
    );
  }
}
