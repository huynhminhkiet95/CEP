import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/models/historyscreen/history_screen.dart';
import 'package:CEPmobile/ui/components/dropdown.dart';
import 'package:CEPmobile/ui/screens/survey/style.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:flutter/services.dart';

class SurveyDetailScreen extends StatefulWidget {
  @override
  _SurveyDetailScreenState createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
  double screenWidth, screenHeight;
  SurveyBloc surVeyBloc;
  Services services;
  int selectedIndex = 0;

  ///
  List<DropdownMenuItem<String>> _surveyRespondentsModelDropdownList;
  final List<String> _surveyRespondentsList = [
    'Thành Viên',
    'Người Thân',
  ];
  String _surveyRespondentsModel;

  List<DropdownMenuItem<String>> _buildSurveyRespondentsModelDropdown(
      List favouriteFoodModelList) {
    List<DropdownMenuItem<String>> items = List();
    for (String favouriteFoodModel in favouriteFoodModelList) {
      items.add(DropdownMenuItem(
        value: favouriteFoodModel,
        child: Text(favouriteFoodModel),
      ));
    }
    return items;
  }

  ///
  //////
  List<DropdownMenuItem<String>> _maritalStatusModelDropdownList;
  final List<String> _maritalStatusList = [
    'Độc Thân',
    'Đã lập gia đình',
    'Góa vợ/chồng',
    'Li dị',
  ];
  String _maritalStatusModel;

  List<DropdownMenuItem<String>> _buildMaritalStatusModelDropdown(
      List maritalStatusModelList) {
    List<DropdownMenuItem<String>> items = List();
    for (String maritalStatusModel in maritalStatusModelList) {
      items.add(DropdownMenuItem(
        value: maritalStatusModel,
        child: Text(maritalStatusModel),
      ));
    }
    return items;
  }

  ///
  //////
  List<DropdownMenuItem<String>> _educationLevelModelDropdownList;
  final List<String> _educationLevelList = [
    'Lớp 1',
    'Lớp 2',
    'Lớp 3',
    'Lớp 4',
    'Lớp 5',
    'Lớp 6',
    'Lớp 7',
    'Lớp 8',
    'Lớp 9',
    'Lớp 10',
    'Lớp 11',
    'Lớp 12',
    'Trung Cấp',
    'Cao Đẳng',
    'Đại Học',
  ];
  String _educationLevelModel;

  List<DropdownMenuItem<String>> _buildEducationLevelModelDropdown(
      List educationLevelModelList) {
    List<DropdownMenuItem<String>> items = List();
    for (String educationLevelModel in educationLevelModelList) {
      items.add(DropdownMenuItem(
        value: educationLevelModel,
        child: Text(educationLevelModel),
      ));
    }
    return items;
  }

  TextEditingController _textDateEditingController = TextEditingController(
      text: FormatDateConstants.convertDateTimeToString(DateTime.now()));

  DateTime selectedDate = DateTime.now();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //       _textDateEditingController.text =
  //           FormatDateConstants.convertDateTimeToString(selectedDate);
  //     });
  // }

  _selectDate(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      //return buildCupertinoDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  Future<DateTime> showDateTime() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      //selectableDayPredicate: _decideWhichDayToEnable,
      helpText: 'Chọn ngày',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Chọn ngày',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    return picked;
  }

  buildMaterialDatePicker(BuildContext context) async {
    DateTime picked = await showDateTime();
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.blue,
            child: CupertinoDatePicker(
              backgroundColor: Colors.white,
              use24hFormat: true,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              initialDateTime: selectedDate,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  @override
  void initState() {
    services = Services.of(context);
    surVeyBloc =
        new SurveyBloc(services.sharePreferenceService, services.commonService);
    surVeyBloc.emitEvent(LoadSurveyEvent());

    _surveyRespondentsModelDropdownList =
        _buildSurveyRespondentsModelDropdown(_surveyRespondentsList);
    _surveyRespondentsModel = _surveyRespondentsList[0];

    _maritalStatusModelDropdownList =
        _buildMaritalStatusModelDropdown(_maritalStatusList);
    _maritalStatusModel = _maritalStatusList[0];

    _educationLevelModelDropdownList =
        _buildEducationLevelModelDropdown(_educationLevelList);
    _educationLevelModel = _educationLevelList[0];
    super.initState();
  }

  _onChangeSurveyRespondentsModelDropdown(String surveyRespondentsModel) {
    setState(() {
      _surveyRespondentsModel = surveyRespondentsModel;
    });
  }

  _onChangeMaritalStatusModelDropdown(String maritalStatusModel) {
    setState(() {
      _maritalStatusModel = maritalStatusModel;
    });
  }

  _onChangeEducationLevelModelDropdown(String educationLevelModel) {
    setState(() {
      _educationLevelModel = educationLevelModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    List<String> listTypeArea = [
      'Thành thị',
      'Nông thôn',
    ];

    List<String> listTypeOfTotalMonth = [
      'Người trả lời biết tổng chi phí',
      'Người trả lời không biết tổng chi phí',
    ];

    textStyle() {
      return new TextStyle(color: Colors.blue, fontSize: 20.0);
    }

    return DefaultTabController(
      length: 5,
      child: new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: ColorConstants.cepColorBackground,
          title: new Text("Cập Nhật Thông Tin Khảo Sát"),
          bottom: PreferredSize(
              child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.indigo.shade200,
                  indicatorColor: Colors.red,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Column(
                        children: [
                          Center(
                            child: Icon(Icons.info),
                          ),
                          Center(
                              child: Text(
                            'Thông Tin',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          Center(
                            child: Icon(IconsCustomize.loan),
                          ),
                          Center(
                              child: Text(
                            'Vay Lần 1',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          Center(
                            child: Icon(Icons.money),
                          ),
                          Center(
                              child: Text(
                            'Nhu Cầu Vốn',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          Center(
                            child: Icon(IconsCustomize.networking),
                          ),
                          Center(
                              child: Text(
                            'Vay Nguồn Khác',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          Center(
                            child: Icon(IconsCustomize.survey_icon),
                          ),
                          Center(
                              child: Text(
                            'Đánh Giá',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                  ]),
              preferredSize: Size.fromHeight(30.0)),
        ),
        body: new TabBarView(
          children: <Widget>[
            /// THÔNG TIN PAGE ///
            new Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    new Center(
                      child: Text(
                        "Thông Tin Thành Viên",
                        style: TextStyle(
                            color: Color(0xff003399),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: new Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Thành Viên:",
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14,
                                  ),
                                ),
                                VerticalDivider(
                                  width: 10,
                                ),
                                Text(
                                  "DUY108 -  Lý Nguyễn Hồng Duy",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Giới Tính:",
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Nam",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "- Năm Sinh:",
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "1984",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "- CMND:",
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "212275568",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Địa chỉ:",
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14,
                                  ),
                                ),
                                VerticalDivider(
                                  width: 10,
                                ),
                                Text(
                                  "102 Quang Trung, P.Hiệp Phú, Quận 9, TPHCM",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Tham gia từ:",
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 14,
                                        ),
                                      ),
                                      VerticalDivider(
                                        width: 10,
                                      ),
                                      Text(
                                        "30-03-2021",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  width: 100,
                                ),
                                Text(
                                  "Vay lần 1",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.42,
                                  child: Text(
                                    "Khu vực",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                customRadio(listTypeArea[0], 0),
                                VerticalDivider(
                                  width: 10,
                                ),
                                customRadio(listTypeArea[1], 1),
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.42,
                                  child: Text(
                                    "Người trả lời khảo sát",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                CustomDropdown(
                                  dropdownMenuItemList:
                                      _surveyRespondentsModelDropdownList,
                                  onChanged:
                                      _onChangeSurveyRespondentsModelDropdown,
                                  value: _surveyRespondentsModel,
                                  width: screenWidth * 0.5,
                                  isEnabled: true,
                                  isUnderline: false,
                                ),
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.42,
                                  child: Text(
                                    "Tình trạng hôn nhân",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                CustomDropdown(
                                  dropdownMenuItemList:
                                      _maritalStatusModelDropdownList,
                                  onChanged:
                                      _onChangeMaritalStatusModelDropdown,
                                  value: _maritalStatusModel,
                                  width: screenWidth * 0.5,
                                  isEnabled: true,
                                  isUnderline: false,
                                ),
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.42,
                                  child: Text(
                                    "Trình độ học vấn",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                CustomDropdown(
                                  dropdownMenuItemList:
                                      _educationLevelModelDropdownList,
                                  onChanged:
                                      _onChangeEducationLevelModelDropdown,
                                  value: _educationLevelModel,
                                  width: screenWidth * 0.5,
                                  isEnabled: true,
                                  isUnderline: false,
                                ),
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.42,
                                  child: Text(
                                    "Ngày khảo sát",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                InkWell(
                                  child: Container(
                                    width: screenWidth * 0.5,
                                    height: 40,
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: ColorConstants
                                              .cepColorBackground, // set border color
                                          width: 1.0), // set border width
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              10.0)), // set rounded corner radius
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0],
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: ColorConstants
                                                  .cepColorBackground),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          size: 17,
                                          color:
                                              ColorConstants.cepColorBackground,
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () => _selectDate(context),
                                )
                                // Text(
                                //   "${selectedDate.toLocal()}".split(' ')[0],
                                //   style: TextStyle(
                                //       fontSize: 13,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // SizedBox(
                                //   height: 20.0,
                                // ),
                                // RaisedButton(
                                //   onPressed: () => _selectDate(context),
                                //   child: Icon(Icons.calendar_today),
                                //   color: Colors.white,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// /////////////////

            /// VAY LẦN 1 PAGE ///
            new Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    new Center(
                      child: Text(
                        "Thông Tin Thành Viên Vay Lần 1 Hoặc Đánh Giá Tác Động",
                        style: TextStyle(
                          color: Color(0xff003399),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: new Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth * 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    elevation: 10,
                                    child: Container(
                                      height: 190,
                                      width: screenWidth * 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5.0),
                                            height: 30,
                                            width: double.infinity,
                                            color: Colors.blue,
                                            child: Text(
                                              "1. Thông tin về tỷ lệ phụ thuộc",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Số người trong hộ gia đình",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Số người có việc làm",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Người)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  /// 2. Thông tin về tài sản hộ gia đình
                                  Card(
                                    elevation: 10,
                                    child: Container(
                                      height: 270,
                                      width: screenWidth * 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5.0),
                                            height: 30,
                                            width: double.infinity,
                                            color: Colors.blue,
                                            child: Text(
                                              "2. Thông tin về tài sản hộ gia đình",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Dụng cụ lao động",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Phương tiện đi lại",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Tài sản sinh hoạt (tivi, đầu đĩa, bàn ghế, tủ lạnh, máy giặt, bếp gas)",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  ///3. Thông tin về điều kiện nhà ở
                                  ///
                                  Card(
                                    elevation: 10,
                                    child: Container(
                                      height: 690,
                                      width: screenWidth * 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5.0),
                                            height: 30,
                                            width: double.infinity,
                                            color: Colors.blue,
                                            child: Text(
                                              "3. Thông tin về điều kiện nhà ở",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Quyền sở hữu",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: CustomDropdown(
                                                dropdownMenuItemList:
                                                    _maritalStatusModelDropdownList,
                                                onChanged:
                                                    _onChangeMaritalStatusModelDropdown,
                                                value: _maritalStatusModel,
                                                width: screenWidth * 1,
                                                isEnabled: true,
                                                isUnderline: true,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Đường/ hẻm trước nhà",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (m2)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Chất lượng nhà",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "- Mái nhà",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: CustomDropdown(
                                                dropdownMenuItemList:
                                                    _maritalStatusModelDropdownList,
                                                onChanged:
                                                    _onChangeMaritalStatusModelDropdown,
                                                value: _maritalStatusModel,
                                                width: screenWidth * 1,
                                                isEnabled: true,
                                                isUnderline: true,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "- Tường",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: CustomDropdown(
                                                dropdownMenuItemList:
                                                    _maritalStatusModelDropdownList,
                                                onChanged:
                                                    _onChangeMaritalStatusModelDropdown,
                                                value: _maritalStatusModel,
                                                width: screenWidth * 1,
                                                isEnabled: true,
                                                isUnderline: true,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "- Nền",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: CustomDropdown(
                                                dropdownMenuItemList:
                                                    _maritalStatusModelDropdownList,
                                                onChanged:
                                                    _onChangeMaritalStatusModelDropdown,
                                                value: _maritalStatusModel,
                                                width: screenWidth * 1,
                                                isEnabled: true,
                                                isUnderline: true,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Diện tích sử dụng",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: CustomDropdown(
                                                dropdownMenuItemList:
                                                    _maritalStatusModelDropdownList,
                                                onChanged:
                                                    _onChangeMaritalStatusModelDropdown,
                                                value: _maritalStatusModel,
                                                width: screenWidth * 1,
                                                isEnabled: true,
                                                isUnderline: true,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Điện",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: CustomDropdown(
                                                dropdownMenuItemList:
                                                    _maritalStatusModelDropdownList,
                                                onChanged:
                                                    _onChangeMaritalStatusModelDropdown,
                                                value: _maritalStatusModel,
                                                width: screenWidth * 1,
                                                isEnabled: true,
                                                isUnderline: true,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Nước",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: CustomDropdown(
                                                dropdownMenuItemList:
                                                    _maritalStatusModelDropdownList,
                                                onChanged:
                                                    _onChangeMaritalStatusModelDropdown,
                                                value: _maritalStatusModel,
                                                width: screenWidth * 1,
                                                isEnabled: true,
                                                isUnderline: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// /////////////////
            /// NHU CẦU VỐN PAGE ///
            new Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    new Center(
                      child: Text(
                        "Thông Tin Nhu Cầu Vốn Thu Nhập, Chi Phí, Tích Lũy",
                        style: TextStyle(
                          color: Color(0xff003399),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: new Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth * 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    elevation: 10,
                                    child: Container(
                                      height: 390,
                                      width: screenWidth * 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5.0),
                                            height: 30,
                                            width: double.infinity,
                                            color: Colors.blue,
                                            child: Text(
                                              "4. Thông tin về nhu cầu vốn",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "4.1 Mụch đích sử dụng vốn",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập tối đa 40 ký tự"),
                                                keyboardType:
                                                    TextInputType.text,
                                                // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "4.2 Số tiền cần cho mục đích sử dụng vốn",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "4.3 Số tiền thành viên đã có",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "4.4 Số tiền thành viên cần vay",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "4.5 Thời điểm sử dụng vốn vay",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: InkWell(
                                                child: Container(
                                                  width: screenWidth * 1,
                                                  height: 40,
                                                  padding: EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: ColorConstants
                                                                  .cepColorBackground)),
                                                      color: Colors.white),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${selectedDate.toLocal()}"
                                                            .split(' ')[0],
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: ColorConstants
                                                                .cepColorBackground),
                                                      ),
                                                      SizedBox(
                                                        width: 20.0,
                                                      ),
                                                      Icon(
                                                        Icons.calendar_today,
                                                        size: 17,
                                                        color: ColorConstants
                                                            .cepColorBackground,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                onTap: () =>
                                                    _selectDate(context),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  /// 2. Thông tin về tài sản hộ gia đình
                                  Card(
                                    elevation: 10,
                                    child: Container(
                                      height: 690,
                                      width: screenWidth * 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5.0),
                                            //  height: 50,

                                            width: screenWidth * 1,
                                            color: Colors.blue,
                                            child: Text(
                                              "5. Thông tin về thu nhập, chi phí, tích lũy hộ gia đình thành viên",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Text(
                                              "5.1 Tổng số vốn đầu tư cho hoạt động tăng thu nhập/ mùa vụ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "5.2 Tổng thu nhập hộ gia đình hàng tháng",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                              "* Thu nhập ròng háng tháng từ hoạt động tăng thu nhập/ mùa vụ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                              "* Thu nhập chồng/vợ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                              "* Thu nhập con",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                              "* Thu nhập từ nguồn khác",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 10),
                                            child: Container(
                                              height: 40,
                                              child: TextField(
                                                style: textStyleTextFieldCEP,
                                                decoration:
                                                    inputDecorationTextFieldCEP(
                                                        "Nhập số (Đồng)"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Text(
                                              "5.3 Nhu nhập bình quân đầu người hàng tháng",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Text(
                                              "5.4 Tổng chi phí hộ gia đình hàng tháng",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: customRadio(listTypeOfTotalMonth[0], 0),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: customRadio(listTypeOfTotalMonth[1], 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// /////////////////
            new Container(
              color: Colors.teal,
              child: new Center(
                child: new Text(
                  "4",
                  style: textStyle(),
                ),
              ),
            ),
            new Container(
              color: Colors.teal,
              child: new Center(
                child: new Text(
                  "5",
                  style: textStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget customRadio(String txt, int index) {
    return OutlineButton(
      onPressed: () => changeIndex(index),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      borderSide: BorderSide(
          color: selectedIndex == index
              ? ColorConstants.cepColorBackground
              : Colors.grey),
      child: Text(
        txt,
        style: TextStyle(
            color: selectedIndex == index
                ? ColorConstants.cepColorBackground
                : Colors.grey),
      ),
    );
  }
}
