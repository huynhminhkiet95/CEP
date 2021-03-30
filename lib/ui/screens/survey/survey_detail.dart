import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/config/formatdate.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/historyscreen/history_screen.dart';
import 'package:CEPmobile/ui/components/CardCustomWidget.dart';
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
  final int id;
  final List<ComboboxModel> listCombobox;
  final SurveyInfo surveyInfo;
  const SurveyDetailScreen(
      {Key key, this.id, this.listCombobox, this.surveyInfo})
      : super(key: key);

  @override
  _SurveyDetailScreenState createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen>
    with SingleTickerProviderStateMixin {
  double screenWidth, screenHeight;
  SurveyBloc surVeyBloc;
  Services services;
  int selectedIndexKhuVuc;
  int selectedIndexTotalMonthly = 0;

  ///
  List<DropdownMenuItem<String>> _surveyRespondentsModelDropdownList;
  List<DropdownMenuItem<String>> _maritalStatusModelDropdownList;
  List<DropdownMenuItem<String>> _educationLevelModelDropdownList;
  List<DropdownMenuItem<String>> _ownershipModelDropdownList;
  List<DropdownMenuItem<String>> _roofModelDropdownList;
  List<DropdownMenuItem<String>> _wallModelDropdownList;
  List<DropdownMenuItem<String>> _floorModelDropdownList;
  List<DropdownMenuItem<String>> _powerModelDropdownList;
  List<DropdownMenuItem<String>> _waterModelDropdownList;

  String _surveyRespondentsValue;
  String _maritalStatusValue;
  String _educationLevelValue;
  String _ownershipValue;
  String _roofValue;
  String _wallValue;
  String _floorValue;
  String _powerValue;
  String _waterValue;

  DateTime selectedSurveyDate;
  DateTime selectedDate = DateTime.now();
  List<DropdownMenuItem<String>> _buildDropdown(
      List<ComboboxModel> listCombobox) {
    List<DropdownMenuItem<String>> items = List();
    items.add(DropdownMenuItem(
      value: '0',
      child: Text('Chọn'),
    ));

    for (var item in listCombobox) {
      items.add(DropdownMenuItem(
        value: item.itemId,
        child: Text(item.itemText),
      ));
    }
    return items;
  }

  TextEditingController _textDateEditingController = TextEditingController(
      text: FormatDateConstants.convertDateTimeToString(DateTime.now()));

  double _animatedHeight1 = 0.0;
  double _animatedHeight2 = 0.0;

  // DateTime _selectDate(BuildContext context, DateTime selectedDate) {
  //   final ThemeData theme = Theme.of(context);
  //   assert(theme.platform != null);
  //   switch (theme.platform) {
  //     case TargetPlatform.android:
  //     case TargetPlatform.fuchsia:
  //     case TargetPlatform.linux:
  //     case TargetPlatform.windows:
  //       return buildMaterialDatePicker(context, selectedDate);
  //     //return buildCupertinoDatePicker(context);
  //     case TargetPlatform.iOS:
  //     case TargetPlatform.macOS:
  //       return buildCupertinoDatePicker(context);
  //   }
  // }

  Future<DateTime> showDateTime(DateTime selectedDate) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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

  buildSurveyDatePicker(BuildContext context, DateTime selectedDateTime) async {
    DateTime picked = await showDateTime(selectedDateTime);
    if (picked != null) {
      setState(() {
        selectedSurveyDate = picked;
      });
    }
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
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    loadInitData();
    services = Services.of(context);
    surVeyBloc =
        new SurveyBloc(services.sharePreferenceService, services.commonService);
    surVeyBloc.emitEvent(LoadSurveyEvent());
    _animatedHeight1 = 60;
    super.initState();
  }

  void loadInitData() {
    // khu vuc
    selectedIndexKhuVuc = widget.surveyInfo.khuVuc;

    /// nguoi tra loi khao sat
    _surveyRespondentsModelDropdownList = _buildDropdown(widget.listCombobox
        .where((e) => e.groupId == 'NguoiTraloiKhaosat')
        .toList());
    _surveyRespondentsValue = widget.surveyInfo.nguoiTraloiKhaoSat;

    /// tinh trang hon nhan
    _maritalStatusModelDropdownList = _buildDropdown(widget.listCombobox
        .where((e) => e.groupId == 'TinhTrangHonNhan')
        .toList());
    _maritalStatusValue = widget.surveyInfo.tinhTrangHonNhan;

    ///trinh do hoc van
    _educationLevelModelDropdownList = _buildDropdown(widget.listCombobox
        .where((e) => e.groupId == 'TrinhDoHocVan')
        .toList());
    _educationLevelValue = widget.surveyInfo.trinhDoHocVan;

    /// quyen so huu
    _ownershipModelDropdownList = _buildDropdown(widget.listCombobox
        .where((e) => e.groupId == 'QuyenSoHuuNha')
        .toList());
    _ownershipValue = widget.surveyInfo.quyenSoHuuNha;

    ///mai nha
    _roofModelDropdownList = _buildDropdown(
        widget.listCombobox.where((e) => e.groupId == 'MaiNha').toList());
    _roofValue = widget.surveyInfo.maiNha;

    ///tuong nha
    _wallModelDropdownList = _buildDropdown(
        widget.listCombobox.where((e) => e.groupId == 'TuongNha').toList());
    _wallValue = widget.surveyInfo.tuongNha;

    ///nen nha
    _floorModelDropdownList = _buildDropdown(
        widget.listCombobox.where((e) => e.groupId == 'NenNha').toList());
    _floorValue = widget.surveyInfo.nenNha;

    ///dien
    _powerModelDropdownList = _buildDropdown(
        widget.listCombobox.where((e) => e.groupId == 'Dien').toList());
    _powerValue = widget.surveyInfo.dien;

    ///nuoc
    _waterModelDropdownList = _buildDropdown(
        widget.listCombobox.where((e) => e.groupId == 'Nuoc').toList());
    _waterValue = widget.surveyInfo.nuoc;
  }

  _onChangeSurveyRespondentsModelDropdown(String surveyRespondentsModel) {
    setState(() {
      _surveyRespondentsValue = surveyRespondentsModel;
    });
  }

  _onChangeMaritalStatusModelDropdown(String maritalStatusModel) {
    setState(() {
      _maritalStatusValue = maritalStatusModel;
    });
  }

  _onChangeEducationLevelModelDropdown(String educationLevelModel) {
    setState(() {
      _educationLevelValue = educationLevelModel;
    });
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndexKhuVuc = index;
    });
  }

  void changeIndexTotalMonthlyRadioButton(int index) {
    setState(() {
      selectedIndexTotalMonthly = index;
      if (index == 1) {
        _animatedHeight1 = 0;
        _animatedHeight2 = 270;
      } else {
        _animatedHeight1 = 60;
        _animatedHeight2 = 0;
      }
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
    return DefaultTabController(
      length: 5,
      child: new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.save_alt_sharp,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pop(context, "OK-ID");
                })
          ],
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
                                  widget.surveyInfo.thanhvienId +
                                      ' - ' +
                                      widget.surveyInfo.hoVaTen,
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
                                  widget.surveyInfo.gioiTinh == 1
                                      ? "Nam"
                                      : "Nữ",
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
                                  widget.surveyInfo.ngaySinh.substring(0, 4),
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
                                  widget.surveyInfo.cmnd,
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
                                  widget.surveyInfo.diaChi,
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
                                        FormatDateConstants
                                            .convertDateTimeToDDMMYYYY(widget
                                                .surveyInfo.thoigianthamgia),
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
                                  "Vay lần ${widget.surveyInfo.lanvay}",
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
                                  value: _surveyRespondentsValue,
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
                                  value: _maritalStatusValue,
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
                                  value: _educationLevelValue,
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
                                          selectedSurveyDate != null
                                              ? "${selectedSurveyDate.toLocal()}"
                                                  .split(' ')[0]
                                              : "",
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
                                  onTap: () {
                                    buildSurveyDatePicker(
                                        context, selectedSurveyDate);
                                  },
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
                                  CardCustomizeWidget(
                                    width: screenWidth * 1,
                                    title: "1. Thông tin về tỷ lệ phụ thuộc",
                                    children: [
                                      Text(
                                        "Số người trong hộ gia đình",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Số người có việc làm",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Người)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// 2. Thông tin về tài sản hộ gia đình
                                  CardCustomizeWidget(
                                    title:
                                        "2. Thông tin về tài sản hộ gia đình",
                                    width: screenWidth * 1,
                                    children: [
                                      Text(
                                        "Dụng cụ lao động",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Phương tiện đi lại",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Tài sản sinh hoạt (tivi, đầu đĩa, bàn ghế, tủ lạnh, máy giặt, bếp gas)",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///3. Thông tin về điều kiện nhà ở
                                  ///
                                  CardCustomizeWidget(
                                    title: "3. Thông tin về điều kiện nhà ở",
                                    width: screenWidth * 1,
                                    children: [
                                      Text(
                                        "Quyền sở hữu",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: CustomDropdown(
                                          dropdownMenuItemList:
                                              _ownershipModelDropdownList,
                                          onChanged: (value) {
                                            setState(() {
                                              _ownershipValue = value;
                                            });
                                          },
                                          value: _ownershipValue,
                                          width: screenWidth * 1,
                                          isEnabled: true,
                                          isUnderline: true,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Đường/ hẻm trước nhà",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (m2)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Chất lượng nhà",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "- Mái nhà",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: CustomDropdown(
                                          dropdownMenuItemList:
                                              _roofModelDropdownList,
                                          onChanged: (value) {
                                            setState(() {
                                              _roofValue = value;
                                            });
                                          },
                                          value: _roofValue,
                                          width: screenWidth * 1,
                                          isEnabled: true,
                                          isUnderline: true,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "- Tường",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: CustomDropdown(
                                          dropdownMenuItemList:
                                              _wallModelDropdownList,
                                          onChanged: (value) {
                                            setState(() {
                                              _wallValue = value;
                                            });
                                          },
                                          value: _wallValue,
                                          width: screenWidth * 1,
                                          isEnabled: true,
                                          isUnderline: true,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "- Nền",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: CustomDropdown(
                                          dropdownMenuItemList:
                                              _floorModelDropdownList,
                                          onChanged: (value) {
                                            setState(() {
                                              _floorValue = value;
                                            });
                                          },
                                          value: _floorValue,
                                          width: screenWidth * 1,
                                          isEnabled: true,
                                          isUnderline: true,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Diện tích sử dụng",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (m2/người)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Điện",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: CustomDropdown(
                                          dropdownMenuItemList:
                                              _powerModelDropdownList,
                                          onChanged: (value) {
                                            setState(() {
                                              _powerValue = value;
                                            });
                                          },
                                          value: _powerValue,
                                          width: screenWidth * 1,
                                          isEnabled: true,
                                          isUnderline: true,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Nước",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: CustomDropdown(
                                          dropdownMenuItemList:
                                              _waterModelDropdownList,
                                          onChanged: (value) {
                                            _waterValue = value;
                                          },
                                          value: _waterValue,
                                          width: screenWidth * 1,
                                          isEnabled: true,
                                          isUnderline: true,
                                        ),
                                      ),
                                    ],
                                  )
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
                                  CardCustomizeWidget(
                                    children: [
                                      Text(
                                        "4.1 Mụch đích sử dụng vốn",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập tối đa 40 ký tự"),
                                          keyboardType: TextInputType.text,
                                          // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "4.2 Số tiền cần cho mục đích sử dụng vốn",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "4.3 Số tiền thành viên đã có",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "4.4 Số tiền thành viên cần vay",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "4.5 Thời điểm sử dụng vốn vay",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
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
                                          // onTap: () => _selectDate(context),
                                        ),
                                      ),
                                    ],
                                    title: "4. Thông tin về nhu cầu vốn",
                                    width: screenWidth * 1,
                                  ),

                                  /// 4. Thông tin về thu nhập, chi phí, tích lũy hộ gia đình thành viên

                                  CardCustomizeWidget(
                                    children: [
                                      Text(
                                        "5.1 Tổng số vốn đầu tư cho hoạt động tăng thu nhập/ mùa vụ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "5.2 Tổng thu nhập hộ gia đình hàng tháng",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "* Thu nhập ròng háng tháng từ hoạt động tăng thu nhập/ mùa vụ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "* Thu nhập chồng/vợ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "* Thu nhập con",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "* Thu nhập từ nguồn khác",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "5.3 Nhu nhập bình quân đầu người hàng tháng",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "5.4 Tổng chi phí hộ gia đình hàng tháng",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: customRadioTotalMonthly(
                                            listTypeOfTotalMonth[0], 0),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 0),
                                        width: screenWidth * 1,
                                        child: new AnimatedContainer(
                                          //transform: ,
                                          duration:
                                              const Duration(milliseconds: 320),

                                          child: Container(
                                            child: ListView(
                                              padding: EdgeInsets.all(0),
                                              children: [
                                                Text(
                                                  "Người trả lời biết tổng chi phí cụ thể",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  child: TextField(
                                                    style:
                                                        textStyleTextFieldCEP,
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
                                              ],
                                            ),
                                          ),
                                          height: _animatedHeight1,
                                          color: Colors.white,

                                          width: 100.0,
                                        ),
                                      ),
                                      Container(
                                        // margin: EdgeInsets.only(top: -20),
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: customRadioTotalMonthly(
                                            listTypeOfTotalMonth[1], 1),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 0),
                                        width: screenWidth * 1,
                                        child: new AnimatedContainer(
                                          //transform: ,
                                          duration:
                                              const Duration(milliseconds: 320),

                                          child: ListView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            children: [
                                              Text(
                                                "* Chi phí điện, nước",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Container(
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
                                              Divider(
                                                height: 10,
                                              ),
                                              Text(
                                                "* Chi phí ăn uống",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Container(
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
                                              Divider(
                                                height: 10,
                                              ),
                                              Text(
                                                "* Chi phí học tập",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Container(
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
                                              Divider(
                                                height: 10,
                                              ),
                                              Text(
                                                "* Chi phí khác",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Container(
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
                                            ],
                                          ),
                                          height: _animatedHeight2,
                                          color: Colors.white,

                                          width: 100.0,
                                        ),
                                      ),
                                      Text(
                                        "5.5 Chi phí đang trả tiền vay CEP hàng tháng (nếu có) (Khi khảo sát thành viên vay vốn bổ sung hoặc khẩn cấp)",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "5.6 Tích lũy hộ gia đình hàng tháng",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "5.7 Tích lũy hàng tháng dự kiến tăng thêm khi sử dụng khoản vay",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                    ],
                                    width: screenWidth * 1,
                                    title:
                                        "5. Thông tin về thu nhập, chi phí, tích lũy hộ gia đình thành viên",
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
            /// /////////////////
            /// VAY NGUỒN KHÁC PAGE ///
            new Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    new Center(
                      child: Text(
                        "Thông Tin Khác",
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
                                  CardCustomizeWidget(
                                    children: [
                                      Text(
                                        "6.1 Nguồn vay 1",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        // child: CustomDropdown(
                                        //   dropdownMenuItemList:
                                        //       _maritalStatusModelDropdownList,
                                        //   onChanged:
                                        //       _onChangeMaritalStatusModelDropdown,
                                        //   value: _maritalStatusModel,
                                        //   width: screenWidth * 1,
                                        //   isEnabled: true,
                                        //   isUnderline: true,
                                        // ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Số tiền",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Lý do vay",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        // child: CustomDropdown(
                                        //   dropdownMenuItemList:
                                        //       _maritalStatusModelDropdownList,
                                        //   onChanged:
                                        //       _onChangeMaritalStatusModelDropdown,
                                        //   value: _maritalStatusModel,
                                        //   width: screenWidth * 1,
                                        //   isEnabled: true,
                                        //   isUnderline: true,
                                        // ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Thời điểm tất toán",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
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
                                          // onTap: () => _selectDate(context),
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Biện pháp thống nhất",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        // child: CustomDropdown(
                                        //   dropdownMenuItemList:
                                        //       _maritalStatusModelDropdownList,
                                        //   onChanged:
                                        //       _onChangeMaritalStatusModelDropdown,
                                        //   value: _maritalStatusModel,
                                        //   width: screenWidth * 1,
                                        //   isEnabled: true,
                                        //   isUnderline: true,
                                        // ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "6.2 Nguồn vay 2",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        // child: CustomDropdown(
                                        //   dropdownMenuItemList:
                                        //       _maritalStatusModelDropdownList,
                                        //   onChanged:
                                        //       _onChangeMaritalStatusModelDropdown,
                                        //   value: _maritalStatusModel,
                                        //   width: screenWidth * 1,
                                        //   isEnabled: true,
                                        //   isUnderline: true,
                                        // ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Số tiền",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Lý do vay",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        // child: CustomDropdown(
                                        //   dropdownMenuItemList:
                                        //       _maritalStatusModelDropdownList,
                                        //   onChanged:
                                        //       _onChangeMaritalStatusModelDropdown,
                                        //   value: _maritalStatusModel,
                                        //   width: screenWidth * 1,
                                        //   isEnabled: true,
                                        //   isUnderline: true,
                                        // ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Thời điểm tất toán",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
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
                                          //   onTap: () => _selectDate(context),
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Biện pháp thống nhất",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        // child: CustomDropdown(
                                        //   dropdownMenuItemList:
                                        //       _maritalStatusModelDropdownList,
                                        //   onChanged:
                                        //       _onChangeMaritalStatusModelDropdown,
                                        //   value: _maritalStatusModel,
                                        //   width: screenWidth * 1,
                                        //   isEnabled: true,
                                        //   isUnderline: true,
                                        // ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                    ],
                                    title:
                                        "6. Thành viên có đang vay nguồn vốn khác",
                                    width: screenWidth * 1,
                                  ),
                                  CardCustomizeWidget(
                                    children: [
                                      Text(
                                        "Thành viên thuộc diện",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        // child: CustomDropdown(
                                        //   dropdownMenuItemList:
                                        //       _maritalStatusModelDropdownList,
                                        //   onChanged:
                                        //       _onChangeMaritalStatusModelDropdown,
                                        //   value: _maritalStatusModel,
                                        //   width: screenWidth * 1,
                                        //   isEnabled: true,
                                        //   isUnderline: true,
                                        // ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Mã số hộ nghèo, hộ cận nghèo",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập chữ và số"),
                                          keyboardType: TextInputType.text,
                                          // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Tên chủ hộ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration: inputDecorationTextFieldCEP(
                                              "Nhập chữ có dấu hoặc không dấu"),
                                          keyboardType: TextInputType.text,
                                          // Only numbers can be entered
                                        ),
                                      ),
                                    ],
                                    title: "7. Thành viên thuộc diện",
                                    width: screenWidth * 1,
                                  ),
                                  CardCustomizeWidget(
                                    children: [
                                      Text(
                                        "Số tiền gửi mỗi kỳ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                    ],
                                    title:
                                        "8. Thành viên có tham gia gửi tiết kiệm định hướng?",
                                    width: screenWidth * 1,
                                  ),
                                  CardCustomizeWidget(
                                    children: [
                                      Text(
                                        "Tiết kiệm bắt buộc",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Tiết kiệm định hướng",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Tiết kiệm linh hoạt",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Thời điểm rút",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          customRadio(listTypeArea[0], 0),
                                          VerticalDivider(
                                            width: 10,
                                          ),
                                          customRadio(listTypeArea[1], 1),
                                        ],
                                      ),
                                      Container(
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
                                          //  onTap: () => _selectDate(context),
                                        ),
                                      ),
                                    ],
                                    title:
                                        "9. Thành viên có tham gia gửi tiết kiệm định hướng?",
                                    width: screenWidth * 1,
                                  ),
                                  CardCustomizeWidget(
                                    children: [
                                      Text(
                                        "Mức vay bổ sung",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Mục đích vay vốn bổ sung",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        // child: CustomDropdown(
                                        //   dropdownMenuItemList:
                                        //       _maritalStatusModelDropdownList,
                                        //   onChanged:
                                        //       _onChangeMaritalStatusModelDropdown,
                                        //   value: _maritalStatusModel,
                                        //   width: screenWidth * 1,
                                        //   isEnabled: true,
                                        //   isUnderline: true,
                                        // ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Ngày nhận vốn bổ sung",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
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
                                          //  onTap: () => _selectDate(context),
                                        ),
                                      ),
                                    ],
                                    width: screenWidth * 1,
                                    title:
                                        "10. Thành viên có đăng ký vay bổ sung",
                                  )

                                  /// 4. Thông tin về thu nhập, chi phí, tích lũy hộ gia đình thành viên
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
            /// ĐÁNH GIÁ PAGE ///
            new Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    new Center(
                      child: Text(
                        "Đánh Giá Và Đề Xuất Duyệt Vay Của Nhân Viên Tín Dụng",
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
                                  CardCustomizeWidget(
                                    children: [],
                                    title:
                                        "11. Phân loại hộ nghèo thành viên vay lần 1",
                                    width: screenWidth * 1,
                                  ),
                                  CardCustomizeWidget(
                                    children: [
                                      Container(
                                        height: 100,
                                        child: TextField(
                                          textInputAction:
                                              TextInputAction.newline,
                                          maxLength: 400,
                                          //keyboardType: TextInputType.text,
                                          maxLines: 8,
                                          keyboardType: TextInputType.multiline,
                                          style: textStyleTextFieldCEP,
                                          decoration: inputDecorationTextFieldCEP(
                                              "Nhập chữ có dấu hoặc không dấu"),
                                          //keyboardType: TextInputType.text,
                                          // Only numbers can be entered
                                        ),
                                      ),
                                    ],
                                    title: "12. Ghi chú của nhân viên tín dụng",
                                    width: screenWidth * 1,
                                  ),
                                  CardCustomizeWidget(
                                    children: [
                                      Text(
                                        "Số tiền",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Tiết kiệm định hướng",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: TextField(
                                          style: textStyleTextFieldCEP,
                                          decoration:
                                              inputDecorationTextFieldCEP(
                                                  "Nhập số (Đồng)"),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                      Text(
                                        "Mục đích",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        // child: CustomDropdown(
                                        //   dropdownMenuItemList:
                                        //       _maritalStatusModelDropdownList,
                                        //   onChanged:
                                        //       _onChangeMaritalStatusModelDropdown,
                                        //   value: _maritalStatusModel,
                                        //   width: screenWidth * 1,
                                        //   isEnabled: true,
                                        //   isUnderline: true,
                                        // ),
                                      ),
                                    ],
                                    title: "13. Đề xuất",
                                    width: screenWidth * 1,
                                  ),
                                  CardCustomizeWidget(
                                    children: [
                                      RawMaterialButton(
                                        fillColor: Colors.green,
                                        splashColor: Colors.blue,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const <Widget>[
                                              Text(
                                                "Phát Triển Cộng Đồng",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {
                                          //  _onSubmit();
                                        },
                                        shape: const StadiumBorder(),
                                      ),
                                    ],
                                    title:
                                        "14. Tham gia chương trình Phát Triển Cộng Đồng",
                                    width: screenWidth * 1,
                                  ),

                                  /// 4. Thông tin về thu nhập, chi phí, tích lũy hộ gia đình thành viên
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
          ],
        ),
      ),
    );
  }

  Widget customRadio(String txt, int index) {
    return OutlineButton(
      onPressed: () => changeIndex(index),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      borderSide: BorderSide(
          color: selectedIndexKhuVuc == index
              ? ColorConstants.cepColorBackground
              : Colors.grey),
      child: Text(
        txt,
        style: TextStyle(
            color: selectedIndexKhuVuc == index
                ? ColorConstants.cepColorBackground
                : Colors.grey),
      ),
    );
  }

  Widget customRadioTotalMonthly(String txt, int index) {
    return OutlineButton(
      onPressed: () => changeIndexTotalMonthlyRadioButton(index),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      borderSide: BorderSide(
          color: selectedIndexTotalMonthly == index
              ? ColorConstants.cepColorBackground
              : Colors.grey),
      child: Text(
        txt,
        style: TextStyle(
            color: selectedIndexTotalMonthly == index
                ? ColorConstants.cepColorBackground
                : Colors.grey),
      ),
    );
  }
}
