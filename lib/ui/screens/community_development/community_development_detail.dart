import 'package:CEPmobile/blocs/survey/survey_bloc.dart';
import 'package:CEPmobile/config/CustomIcons/my_flutter_app_icons.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/resources/CurrencyInputFormatter.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:CEPmobile/ui/components/dropdown.dart';
import 'package:CEPmobile/ui/css/style.css.dart';
import 'package:CEPmobile/ui/screens/survey/style.dart';
import 'package:flutter/material.dart';

import 'community_development.style.dart';

class CommunityDevelopmentDetail extends StatefulWidget {
  final int id;
  final List<ComboboxModel> listCombobox;
  CommunityDevelopmentDetail({Key key, this.id, this.listCombobox})
      : super(key: key);

  @override
  _CommunityDevelopmentDetailState createState() =>
      _CommunityDevelopmentDetailState();
}

class _CommunityDevelopmentDetailState extends State<CommunityDevelopmentDetail>
    with SingleTickerProviderStateMixin {
  double screenWidth, screenHeight;
  int selectedIndexKhuVuc;
  TextEditingController _controllerCareerSpecific =
      new TextEditingController(text: "");
  TextEditingController _controllerAmountOfLaborTools =
      new TextEditingController(text: "");

  List<DropdownMenuItem<String>> _surveyRespondentsModelDropdownList;
  TextStyle textStyleTextFieldCEP =
      TextStyle(color: ColorConstants.cepColorBackground, fontSize: 14);
  String _surveyRespondentsValue;
  TabController _tabController;

  List<String> listTypeArea = [
    'Có',
    'Không',
  ];
  SurveyBloc surVeyBloc;
  Services services;

  void changeIndex(int index) {
    setState(() {
      selectedIndexKhuVuc = index;
    });
  }

  void loadInitData() {
    _tabController = new TabController(length: 2, vsync: this);
    _surveyRespondentsModelDropdownList = _buildDropdown(widget.listCombobox
        .where((e) => e.groupId == 'NgheNghiep')
        .toList());
    _surveyRespondentsValue = "0";
  }

  @override
  void initState() {
    loadInitData();
    services = Services.of(context);
    surVeyBloc =
        new SurveyBloc(services.sharePreferenceService, services.commonService);
    //surVeyBloc.emitEvent(LoadSurveyEvent());
    super.initState();
  }

  _onChangeSurveyRespondentsModelDropdown(String surveyRespondentsModel) {
    setState(() {
      _surveyRespondentsValue = surveyRespondentsModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          backgroundColor: ColorConstants.cepColorBackground,
          elevation: 20,
          title: const Text('Chi Tiết Phát triển Cộng Đồng'),
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.blueGrey.shade300,
            indicatorColor: Colors.red,
            labelColor: Colors.white,
            tabs: [
              Tab(
                child: Column(
                  children: [
                    Center(
                      child: Icon(Icons.list),
                    ),
                    Center(
                        child: Text(
                      'Thông Tin Thành Viên',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Center(
                      child: Icon(IconsCustomize.insurance),
                    ),
                    Center(
                        child: Text(
                      'Chương Trình PT Cộng Đồng',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(
          children: [
            tabbarContent1(),
            tabbarContent1(),
          ],
          controller: _tabController,
        ));
  }

  Widget tabbarContent1() => Container(
        padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 20),
        color: Colors.grey[200],
        child: ListView(
          children: [
            Center(child: titleHeader),
            divider15,
            Card(
              elevation: 20,
              color: Colors.brown[100],
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            labelCard("Chi nhánh"),
                            cardVerticalDivider,
                            labelValue("10"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            labelCard("Lần vay"),
                            cardVerticalDivider,
                            labelValue("1"),
                          ],
                        ),
                      ],
                    ),
                    divider15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        labelCard("Thành viên:"),
                        cardVerticalDivider,
                        labelValue("KIET365 - HUYNH MINH KIET"),
                      ],
                    ),
                    divider15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            cardIcon(IconsCustomize.birth_date),
                            cardVerticalDivider,
                            labelValue("15-02-1960"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              IconsCustomize.gender,
                              size: 20,
                              color: Colors.blue,
                            ),
                            cardVerticalDivider,
                            labelValue("Nữ"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_iphone,
                              color: Colors.blue,
                            ),
                            cardVerticalDivider,
                            labelValue("384769378"),
                          ],
                        ),
                      ],
                    ),
                    divider15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        ),
                        cardVerticalDivider,
                        SizedBox(
                          width: screenWidth * 0.80,
                          child: Text(
                            "102 Quang Trung,P.Hiệp Phú, Quận 9, TP Thủ Đức",
                            style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    divider15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              color: Colors.blue,
                            ),
                            cardVerticalDivider,
                            labelValue("14-08-2008"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            labelCard("Mã số hộ nghèo:"),
                            cardVerticalDivider,
                            labelValue("123XX2"),
                          ],
                        ),
                      ],
                    ),
                    divider15,
                  ],
                ),
              ),
            ),
            divider15,
            Card(
              elevation: 20,
              color: Colors.grey[200],
              borderOnForeground: false,
              clipBehavior: Clip.hardEdge,
              shadowColor: Colors.grey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                    ),
                    padding: EdgeInsets.all(5.0),
                    width: double.infinity,
                    child: Container(
                      width: screenWidth * 0.77,
                      child: Text(
                        "Có vợ/chồng/con là CNV",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        customRadio(listTypeArea[0], 1),
                        VerticalDivider(
                          width: 10,
                          color: Colors.grey.withOpacity(0),
                        ),
                        customRadio(listTypeArea[1], 0),
                      ],
                    ),
                  )
                ],
              ),
            ),
            divider15,
            Card(
              elevation: 20,
              color: Colors.grey[200],
              borderOnForeground: false,
              clipBehavior: Clip.hardEdge,
              shadowColor: Colors.grey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                    ),
                    padding: EdgeInsets.all(5.0),
                    width: double.infinity,
                    child: Container(
                      width: screenWidth * 0.77,
                      child: Text(
                        "Mô hình nghề hiệu quả",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        customRadio(listTypeArea[0], 1),
                        VerticalDivider(
                          width: 10,
                          color: Colors.grey.withOpacity(0),
                        ),
                        customRadio(listTypeArea[1], 0),
                      ],
                    ),
                  )
                ],
              ),
            ),
            divider15,
            Card(
              elevation: 20,
              color: Colors.grey[200],
              borderOnForeground: false,
              clipBehavior: Clip.hardEdge,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          //width: screenWidth * 0.38,
                          child: Text(
                            "Nghề nghiệp",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        CustomDropdown(
                          dropdownMenuItemList:
                              _surveyRespondentsModelDropdownList,
                          onChanged: _onChangeSurveyRespondentsModelDropdown,
                          value: _surveyRespondentsValue,
                          width: screenWidth * 0.5,
                          isEnabled: true,
                          isUnderline: false,
                        ),
                      ],
                    ),
                    Divider(
                      height: 8,
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.38,
                          child: Text(
                            "Nghề nghiệp cụ thể",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            child: TextField(
                              controller: _controllerCareerSpecific,
                              style: textStyleTextFieldCEP,
                              decoration: inputDecorationTextFieldCEP(
                                  "Nhập tối đa 40 ký tự"),
                              keyboardType: TextInputType.text,
                              // Only numbers can be entered
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 8,
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.38,
                          child: Text(
                            "Thu nhập hàng tháng của hộ",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            style: textStyleTextFieldCEP,
                            controller: _controllerAmountOfLaborTools,
                            decoration: inputDecorationTextFieldCEP(
                                "Nhập số tiền...",
                                suffixText: "VNĐ"),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              CurrencyInputFormatter(),
                            ], // Only numbers can be entered
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );

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
}
