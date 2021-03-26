import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/models/historyscreen/history_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/CustomIcons/my_flutter_app_icons.dart';
import 'package:CEPmobile/ui/screens/survey/listofsurveymembers.dart';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/blocs/survey/survey_bloc.dart';
import 'package:CEPmobile/blocs/survey/survey_event.dart';
import 'package:CEPmobile/blocs/survey/survey_state.dart';
import 'package:CEPmobile/bloc_widgets/bloc_state_builder.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/blocs/survey/survey_bloc.dart';
import 'package:CEPmobile/blocs/survey/survey_event.dart';
import 'package:CEPmobile/blocs/survey/survey_state.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/ui/components/ModalProgressHUDCustomize.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  double screenWidth, screenHeight;
  int _selectedIndex = 0;
  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  SurveyBloc surVeyBloc;
  Services services;
  List<Widget> _widgetOptions;
  List<CheckBoxSurvey> checkBoxSurvey = new List<CheckBoxSurvey>();
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
 Widget getItemListView(List<SurveyInfo> listSurvey) {
    for (var item in listSurvey) {
      var model = new CheckBoxSurvey();
      model.id = item.id;
      model.status = false;
      checkBoxSurvey.add(model);
    }

    int count = listSurvey != null ? listSurvey.length : 0;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: (){
            Navigator.pushNamed(context, 'surveydetail');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(13),
              ),
              color: Colors.blue,
            ),
            height: 130,
            child: Card(
              elevation: 10,
              shadowColor: Colors.blue,
              color: Colors.white,
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 8),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.blue,
                      value: checkBoxSurvey[i].status,
                      onChanged: (bool value) {
                        setState(() {
                          this.checkBoxSurvey[i].status = value;
                        });
                      },
                    ),
                    Container(
                      width: 290,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                  elevation: 3,
                                  color: Colors.red,
                                  child: Container(
                                    height: 20,
                                    width: 80,
                                    child: Text(
                                      "Đã Khảo Sát",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  )),
                              Card(
                                  elevation: 3,
                                  color: Colors.red[900],
                                  child: Container(
                                    height: 20,
                                    width: 120,
                                    child: Text(
                                      "Bắt Buộc Khảo Sát",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  )),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              "${listSurvey[i].thanhvienId} - ${listSurvey[i].hoVaTen}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      IconsCustomize.gender,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                    VerticalDivider(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 30,
                                      child: Text(
                                        listSurvey[i].gioiTinh == 0
                                            ? "Nữ"
                                            : "Nam",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Icon(IconsCustomize.gender),
                                //     Text("Nữ",
                                //     style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                                //   ],
                                // ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      IconsCustomize.birth_date,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    VerticalDivider(
                                      width: 10,
                                    ),
                                    VerticalDivider(
                                      width: 1,
                                    ),
                                    Text(
                                      listSurvey[i].ngaySinh.substring(0, 4),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      IconsCustomize.id_card,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    VerticalDivider(
                                      width: 15,
                                    ),
                                    Text(
                                      listSurvey[i].cmnd,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.only(left: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                                VerticalDivider(
                                  width: 1,
                                ),
                                Container(
                                  width: 230,
                                  child: Text(
                                    listSurvey[i].diaChi,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  @override
  void initState() {
    
    
    services = Services.of(context);
    surVeyBloc =
        new SurveyBloc(services.sharePreferenceService, services.commonService);
    surVeyBloc.emitEvent(LoadSurveyEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    _widgetOptions = <Widget>[
      Container(
      color: Colors.blue,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: screenHeight * 0.07,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text(
                  "Danh Sách Thành Viên Khảo Sát",
                  style: TextStyle(
                      color: Color(0xff003399),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              backgroundColor: Colors.white),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Container(
                  height: orientation == Orientation.portrait
                      ? screenHeight * 0.17
                      : screenHeight * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.elliptical(260, 100)),
                    color: Colors.white,
                  ),
                  //color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                                elevation: 4.0,
                                child: Container(
                                  height: 30,
                                  width: 90,
                                  child: Center(
                                    child: Text(
                                      "Cụm ID (10)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xff9596ab)),
                                    ),
                                  ),
                                )),
                            Card(
                                elevation: 4.0,
                                child: Container(
                                  height: 30,
                                  width: 90,
                                  child: Center(
                                    child: Text(
                                      "B047",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                                elevation: 4.0,
                                child: Container(
                                  height: 30,
                                  width: 150,
                                  child: Center(
                                    child: Text(
                                      "Ngày Xuất Danh Sách",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xff9596ab)),
                                    ),
                                  ),
                                )),
                            Card(
                                elevation: 4.0,
                                child: Container(
                                  height: 30,
                                  width: 90,
                                  child: Center(
                                    child: Text(
                                      "18-06-2020",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: orientation == Orientation.portrait
                      ? screenHeight * 0.6
                      : screenHeight * 0.654,
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RawMaterialButton(
                            fillColor: Colors.grey,
                            splashColor: Colors.green,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                                  Icon(
                                    Icons.system_update,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Cập Nhật Lên Server",
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {},
                            shape: const StadiumBorder(),
                          ),
                          RawMaterialButton(
                            fillColor: Colors.grey,
                            splashColor: Colors.green,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Chọn Tất Cả",
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {},
                            shape: const StadiumBorder(),
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          height: orientation == Orientation.portrait
                              ? screenHeight * 0.52
                              : screenHeight * 0.5,
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: ColorConstants.cepColorBackground),
                          child: BlocEventStateBuilder<SurveyState>(
                            bloc: surVeyBloc,
                            builder: (BuildContext context, SurveyState state) {
                              return ModalProgressHUDCustomize(
                                inAsyncCall: state?.isLoading ?? false,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: StreamBuilder<List<SurveyInfo>>(
                                      stream: surVeyBloc.getSurveys,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<SurveyInfo>>
                                              snapshot) {
                                        List<SurveyInfo> listSurvey =
                                            snapshot.data;
                                        if (listSurvey == null) {
                                          return Container(
                                            child: null,
                                          );
                                        } else {
                                          return getItemListView(listSurvey);
                                        }
                                      }),
                                ),
                              );
                            },
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
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
              Navigator.of(context).pop();
            }),
        backgroundColor: ColorConstants.cepColorBackground,
        elevation: 20,
        title: const Text('Khảo Sát Vay Vốn'),
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // bottomNavigationBar: ConvexAppBar(
      //     height: 60,
      //     items: [
      //       TabItem(
      //         icon: Icons.list,
      //         title: orientation == Orientation.portrait
      //             ? 'Danh S...'
      //             : 'Danh Sách',
      //       ),
      //       TabItem(icon: Icons.info, title: 'Thông Tin'),
      //       TabItem(icon: IconsCustomize.loan, title: 'Vay Lần 1'),
      //       TabItem(
      //           icon: Icons.money,
      //           title: orientation == Orientation.portrait
      //               ? 'Nhu Cầu...'
      //               : 'Nhu Cầu Vốn'),
      //       TabItem(
      //           icon: IconsCustomize.networking,
      //           title: orientation == Orientation.portrait
      //               ? 'Vay Ng...'
      //               : 'Vay Nguồn Khác'),
      //       TabItem(icon: IconsCustomize.survey_icon, title: 'Đánh Giá'),
      //     ],
      //     //curveSize: 100,
      //     //initialActiveIndex: 3,
      //     onTap: onItemTapped,
      //     activeColor: Colors.white,
      //     backgroundColor: ColorConstants.cepColorBackground),
    );
  }
}
